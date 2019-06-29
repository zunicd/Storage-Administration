#!/usr/bin/ksh
#
# running an XIV command on all XIVs in one site
#
# February/12/2014 Damir Zunic
#
# adjust the following lines for your environment
# $HOME is home directory environment variable
# for example: /home/dzunic
#
#set -x
BASE_DIR=$HOME/XIV/XIVscripts
HOST_DIR=$BASE_DIR/host_lists
SITEF=$HOST_DIR/SITES.txt
INVF=$HOST_DIR/xiv_inv.txt
XCLI=$HOME/XIV_GUI/xcli
SASGUI_DIR=$HOME/.sasgui
# default user
DEFUSER=us2d9999

# END of adjustment part

echo -e "\n==============="
echo -e "CHOOSE THE SITE"
echo -e "===============\n"

awk '{print NR ".\t" $0}' $SITEF

echo -en "\nType the Site Number:> "
read recns

# short name
SITE=`awk 'NR == '$recns' {print $1}' $SITEF`
if [[ -z $SITE ]]
then
  echo -e "\nIncorrect Site Number: $recns"
  echo -e "Try Again\n"
  exit 0
fi
# long name
FSITE=`awk 'NR == '$recns' {print substr($0, index($0,$2))}' $SITEF`

#
# check the tunnel in SASGUI
#
FSITE1=`echo $FSITE | awk '{print$1}'`
if [[ $FSITE1 == Allianz ]]
then
tn=`awk '(/closing connection/ || /starting connection/) && /'"$FSITE"'/ ' $SASGUI_DIR/sasgui.log | tail -1`
else
tn=`awk '(/closing connection/ || /starting connection/) && /'"$FSITE"' \(/ ' $SASGUI_DIR/sasgui.log | egrep "ID2" | tail -1`
fi

status=`echo $tn | awk '{print $2}'`
if [[ $status != starting ]]
then
  echo -e "\nNot Connected to $SITE - $FSITE"
  echo -e "Check IBM SASGUI for Tunnels\n"
  exit 1
fi

#
# End of SASGUI tunnel checking
#

# check XIV existence in the site
awk '$1 == "'$SITE'"' $INVF | grep $SITE > /dev/null
xivc=$?
if [[ $xivc != 0 ]]
then
  echo -e "\nThere are no XIVs in $SITE\n"
  echo -e "Connect to another site\n"
  exit 2
fi

echo -n "Enter XCLI Command:> "
read COMM

#
# Sign in
#
echo -n "Enter username [$DEFUSER]:> "
read USER
[[ -z $USER ]] && USER=$DEFUSER

if [[ $SITE = RTPS && $USER != admin ]]
then
  USER=$USER@ssm.sdc.gts.ibm.com
fi

if [[ ($SITE = PHN || $SITE = EDS) && $USER != admin ]]
then
  USER=$USER@sma.cmsalz.ibm.allianz
fi

#uncomment the line below if you do not want pw to be seen when you are typing
#stty -echo
echo -n "Enter password for $USER:> "
read PW
stty echo
echo

echo -e "*****  SITE: $SITE  *****\n*****  RUNNING: $COMM  *****\n" 

fname=`basename $0 .ksh`
ftime=`date +%H%M%S`
tmpf=$fname"_"$ftime.tmp

awk '$1 == "'$SITE'" {print substr($0, index($0,$2))}' $INVF > $HOST_DIR/$tmpf

exec 4<$HOST_DIR/$tmpf
while read -u4 HOSTN SERN HOSTIP MODEL
do

  echo "           $HOSTN-$SERN ($HOSTIP)" 

  $XCLI -m $HOSTIP -u $USER -p $PW $COMM

  echo

done

echo

if [[ -a $HOST_DIR/$tmpf ]]
then
  rm $HOST_DIR/$tmpf
fi

exit 0
