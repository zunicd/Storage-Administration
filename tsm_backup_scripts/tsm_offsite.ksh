#!/bin/ksh -x
########################################################################
# Script                ==> /sysadmin/scripts/tsm_offsite.ksh
# Scheduler Node        ==> USTADM
#  Job Set              ==> Tivoli Storage Manager
#  Job Number(s)        ==> 
# Function              ==> Produce and print listing of tapes to send 
#			    to offsite 
# Notes                 ==> The script runs on each of multiple TSM servers. 
#			    It checks randomly for the token on other servers
#			    in the loop and if it does not see the token, it 
#			    creates the token itself and starts ejecting tapes. 
#			    Once all tapes are ejected, it deletes the token 
#			    and allows other servers to take the token and eject
#			    their tapes.
#			    A dummy TSM script represents a token.

#######################################################################
# 08/12/04      DZ		Added checking for tapes in I/O slots
#				Modified report list 
#				Added contacts in the report
########################################################################
#/CAUNIC/bin/enfcontrol JOB TRIGGER EXITLAST
#/CAUNIC/bin/enfcontrol JOB RC EXITLAST

umask 022

DATE=`date +%m%d-%H%M`
DATE1=`date "+%B %d, %Y"`

EmailList=dzunic@us.ibm.com,coffeyma@us.ibm.com,taperich@us.ibm.com,Hollacep@us.ibm.com,eltonben@us.ibm.com,faughn@us.ibm.com,adillard@us.ibm.com,cmusial@us.ibm.com
TSMEmail=dzunic@us.ibm.com,coffeyma@us.ibm.com

tsmsrv=`echo $1 | awk '{print toupper($1)}'`

case $tsmsrv in
    "VATSM01A")     tokens="VATSM01B VATSM01C VATSM02A VATSM02B";;
    "VATSM01B")     tokens="VATSM01A VATSM01C VATSM02A VATSM02B";;
    "VATSM01C")     tokens="VATSM01A VATSM01B VATSM02A VATSM02B";;
    "VATSM02A")     tokens="VATSM01A VATSM01B VATSM01C VATSM02B";;
    "VATSM02B")     tokens="VATSM01A VATSM01B VATSM01C VATSM02A";;
             *)     mailx -s "Incorrect TSM server name: $tsmsrv" $TSMEmail < /dev/null
                    exit 33;;
esac

# token that will be created on this server
ctoken=`echo $tsmsrv | awk '{print "token" tolower(substr($1,7,2))}'`

usr=$2
pw=$3

librmgr=VATSM01A
ioslots=30
libdevice=smc2
#
# number of 60 seconds increments between two reminders to empty the library:
#       remind1 - before starting checkout process
#       remind2 - to allow continuation of the process
remind1=10
remind2=20
RANDOM=$SECONDS

INDX=`echo $tsmsrv | awk '{print substr($1,1,2) substr($1,6,3)}'`

REPORTFILE=/sysadmin/tsm/logs/tsm.offsite.rpt.$INDX.$DATE
EMAILFILE=/tmp/tsm.offsite_email.$INDX
CMDFILE=/sysadmin/tsm/logs/tsm.offsite.cmd.$INDX.$DATE
SENDTO=/sysadmin/tsm/data/sendaddress.txt
CONTACTS=/sysadmin/tsm/data/contacts.txt

contact="appropriate person from the bellow list"
donotreply="Please DO NOT reply directly to this message.\nPlease contact $contact for all concerns relating to this message.\n\n"

set -o noglob
integer tapes_in_ee
integer tapes_to_unload
integer tapes_unloaded
tapes_in_ee=0
tapes_to_unload=0
tapes_unloaded=0

function tokencheck {
#
# Check for tokens on other servers
# If token exists, loop until it is deleted
# If there are no tokens create local token script
# rca=0 when all tokens do not exist, rca=1 when at least one token exists
# $mail: $1=0 - email for the first checking
#        $1=1 - no emails at all
#
set -x
mail=$1-1
while :
do
  rca=0
  (( mail = mail + 1 ))
  for tsmtok in `echo $tokens`
  do
    dsmadmc -id=$usr -password=$pw -se=$tsmtok q script token* > /dev/null
    rc=$?
    if [[ $rc = 0 ]]
    then
      rca=1
      if [[ $mail = 0 ]]
      then
        print "\nToken exists on another server!!\n\nNeed manual intervention!!!\n" > $EMAILFILE
        mailx -s "$tsmsrv: TSM Offsite Report - Token exists on another server!!!" $TSMEmail < $EMAILFILE
      fi
      break
    fi
  done
  [[ $rca = 0 ]] && break
  ((sleept = ($RANDOM % 30) + 90 ))
  sleep $sleept
done
}

#
# check for tokens
#
  tokencheck 1

####  ((sleept = ($RANDOM % 10) + 5 ))
####  sleep $sleept

# create local token script
dsmadmc -id=$usr -password=$pw -se=$tsmsrv def script $ctoken 
rc=$?
if [[ $rc -ne 0 ]]
then
   print "\nToken script $ctoken could not be created!!\n\nNeed manual intervention!!!\n" > $EMAILFILE
   mailx -s "$tsmsrv: TSM Offsite Report - Token creation problem!!!" $TSMEmail < $EMAILFILE
   exit 15
fi

print "$tsmsrv: TSM Offsite Tape Report for $DATE1" > $REPORTFILE
print "============================================================\n" >> $REPORTFILE
print "$donotreply" >> $REPORTFILE

#
# Create command file
#
dsmadmc -id=$usr -pa=$pw -se=$tsmsrv q drm wherestate=mount format=cmd cmd="'dsmadmc -id=$usr -pa=$pw -se=$tsmsrv move drm &vol wherestate=mountable tostate=vault remove=bulk wait=yes'" cmdfile=$CMDFILE 
#
# Check if there are offsite tapes
#
rc=$?
if (($rc > 0))
then
   print "############################################################" >> $REPORTFILE
   print "$tsmsrv: No tapes to be sent offsite for $DATE1 " >> $REPORTFILE
   print "############################################################\n\n" >> $REPORTFILE
   cat $CONTACTS >> $REPORTFILE
   mailx -s "$tsmsrv: No Offsite tapes for $DATE1" $EmailList < $REPORTFILE
#
# Remove the token script
#
   dsmadmc -id=$usr -password=$pw -se=$tsmsrv del script $ctoken
   rc=$?
   if [[ $rc -ne 0 ]]
   then
      print "\n Token script $ctoken could not be removed!!" > $EMAILFILE
      mailx -s "$tsmsrv: TSM Offsite Report - Token removal problem" $TSMEmail < $EMAILFILE
      exit 1
   fi

   exit 0
fi

#
# Check if library is empty before you start checkout process
#
# incr - time increment between two library checkings
incr=9

#   checking if all I/O Slots are emptY
#       exit code # - number of tapes in I/O slots (except 222)
#       exit code 0 - I/O slot is empty
#       exit code 222 - tapeutil: Resource temporarily unavailable

rc=5
until (($rc == 0))
do
  /sysadmin/tsm/scripts/tapesinIO.ksh $libdevice > /dev/null 2>&1
  rc=$?
  if [[ $rc -eq 222 ]]
  then
    mailx -s "Tapeutil: $tsmsrv Library Temporarily Unavailable (11 consecutive attempts)" $TSMEmail < /dev/null
  elif [[ $rc -ne 0 ]]
  then
    ((incr=incr+1))
    if [[ $incr -eq $remind1 ]]
    then
      print "$donotreply\n\n" > $EMAILFILE
      print "========================================================" >> $EMAILFILE
      print "      PLEASE UNLOAD ALL TAPES FROM THE I/O STATION" >> $EMAILFILE
      print "        TO ALLOW EXECUTION OF THE OFFSITE SCRIPT" >> $EMAILFILE
      print "========================================================\n\n" >> $EMAILFILE
      cat $CONTACTS >> $EMAILFILE
      mailx -s "$tsmsrv: TSM Offsite Tape Unloading - Please empty I/O" $EmailList < $EMAILFILE
      incr=0
    fi
    sleep 60
  fi
done

# Library is empty, continue with offsite script
#
# good grammar for report
#
wtape=tapes
have=have
tapes_to_unload=`cat $CMDFILE | wc -l`
[[ $tapes_to_unload -eq 1 ]] && { wtape=tape; have=has; }

print "\nOffsite tape unloading will begin momentarily...\n\n" >> $REPORTFILE
print "The following $tapes_to_unload $wtape $have to be sent offsite\n" >> $REPORTFILE
print "         Volume       State          Date      Storage Pool\n          Name                                     Name\n        --------  --------------  ----------  --------------" >> $REPORTFILE

dsmadmc -id=$usr -password=$pw -se=$tsmsrv -tab select "volume_name,state,upd_date,stgpool_name,voltype from drmedia where state='MOUNTABLE'"|sed 1,9d |grep -v ANS|grep '.' |sed 's/-/ /g'|awk '$7 == "" {$7 = $8} {print NR ".\t" $1 "L1" "    " $2 "     " $4"/"$5"/"$3 "     " $7}' | expand -8 >> $REPORTFILE

print "\n\n=====================================================================" >> $REPORTFILE
print "     End of the $tsmsrv Offsite Tape Report for $DATE1" >> $REPORTFILE
print "=====================================================================\n\n" >> $REPORTFILE

cat $SENDTO >> $REPORTFILE
echo >> $REPORTFILE
cat $CONTACTS >> $REPORTFILE

ctape=`echo $wtape | awk '{print toupper($1)}'`

mailx -s "$tsmsrv: TSM Offsite Report for $DATE1 - $tapes_to_unload $ctape" $EmailList < $REPORTFILE

#
# wait for dismount of DB backup tape
# tapes_to_unload_red=tapes_to_unload-4 reduced number of tapes to unload
# in case there are more db backup volumes at the end of the list
# that makes longer wait time
#
((tapes_to_unload_red = tapes_to_unload - 4 ))
[[ $tapes_to_unload_red -lt $ioslots ]] && sleep 150
sleep 60

#
# check for token on other servers
# if it exists, send email after first checking and loop forever
#
tokencheck 0

set=0
#
# tsets - total number of sets 
# if modulo different than 0 tsets=tsets+1
#
((tsets = tapes_to_unload / ioslots ))
((mset = tapes_to_unload % ioslots ))
[[ $mset -ne 0 ]] && ((tsets = tsets + 1 ))

exec 5< $CMDFILE
while read -u5 command
do
  $command 
  sleep 2
  ((tapes_unloaded = tapes_unloaded + 1))
  ((tapes_in_ee = tapes_in_ee + 1))
  if ((tapes_in_ee == ioslots)) || ((tapes_unloaded == tapes_to_unload)) 
  then
    ((set=set+1))
#  good grammar for reminders
    wtape=TAPES
    be=are
# Prepare output message variables
    if [[ $tapes_unloaded -eq $tapes_to_unload ]]
    then
       [[ $tapes_in_ee -eq 1 ]] && { wtape=TAPE; be=is; }
       [[ $set -eq $tsets ]] && ord="LAST "
       [[ $tsets -eq 1 ]] && ord=""
    else
       [[ $set -eq 1 ]] && ord="FIRST "
       [[ $set -gt 1 ]] && ord="NEXT "
    fi
#
# if this server is library client
# check for checkout completion on library manager
# continue when all volumes are checked out
#
    if [[ $tsmsrv != $librmgr ]]
    then
      rcode=0
      while (($rcode == 0))
      do
        sleep 30
        dsmadmc -id=$usr -password=$pw -comma -se=$librmgr -datao=yes q pr | grep "SHARED CHECKOUT LIBVOL"
        rcode=$?
      done
    fi
#
# send email that tapes are in I/O
#
    print "$donotreply\n\n" > $EMAILFILE
    print "============================================" >> $EMAILFILE
    print "        PLEASE UNLOAD $ord$tapes_in_ee $wtape" >> $EMAILFILE
    print "============================================\n\n" >> $EMAILFILE
    cat $CONTACTS >> $EMAILFILE
    mailx -s "$tsmsrv: TSM Offsite Tape Unloading - $ord$tapes_in_ee $wtape $be in I/O" $EmailList < $EMAILFILE
     
# allow 120 seconds to remove the tapes
    sleep 120
#
# incr - time increment between two library checkings
    incr=0

#   checking if all I/O Slots are emptY
#       exit code # - number of tapes in I/O slots (except 222)
#       exit code 0 - I/O slot is empty
#       exit code 222 - tapeutil: Resource temporarily unavailable

    rc=5
    until (($rc == 0))
    do
       /sysadmin/tsm/scripts/tapesinIO.ksh $libdevice > /dev/null 2>&1
       rc=$?
       if [[ $rc -eq 222 ]]
       then
         mailx -s "Tapeutil: $tsmsrv Library Temporarily Unavailable (11 consecutive attempts)" $TSMEmail < /dev/null
       elif [[ $rc -ne 0 ]]
       then
#
# send reminder every 60*remind2 seconds
#
         ((incr=incr+1))
         if [[ $incr -eq $remind2 ]]
         then
           print "$donotreply\n\n" > $EMAILFILE
           print "============================================" >> $EMAILFILE
           print "        PLEASE UNLOAD $ord$tapes_in_ee $wtape" >> $EMAILFILE
           print "============================================\n\n" >> $EMAILFILE
           cat $CONTACTS >> $EMAILFILE
           mailx -s "$tsmsrv: TSM Offsite Tape Unloading - Remainder" $EmailList < $EMAILFILE
           incr=0
         fi
         sleep 60
       fi
    done
    tapes_in_ee=0
  fi
done

print "$donotreply\n$tsmsrv: TSM Offsite Tape Unloading Process Completed\n\n" > $EMAILFILE
cat $CONTACTS >> $EMAILFILE

mailx -s "$tsmsrv: TSM Offsite Report - End of Process" $EmailList < $EMAILFILE
#
# Remove the token script
#
dsmadmc -id=$usr -password=$pw -se=$tsmsrv del script $ctoken
rc=$?
if [[ $rc -ne 0 ]]
then
   print "\n Token script $ctoken could not be removed!!" > $EMAILFILE
   mailx -s "$tsmsrv: TSM Offsite Report - Token removal problem" $TSMEmail < $EMAILFILE
   exit 0
fi

exit 0
