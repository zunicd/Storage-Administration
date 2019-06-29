#!/usr/bin/ksh
#
# running an XIV ups_list with custom parameters for one or multiple XIVs
#
# February/12/2014 Damir Zunic
#
# adjust the following lines for your environment
# $HOME is home directory environment variable
# for example: /home/dzunic
#
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


echo "XIV Health Check for $SITE - START"

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

echo -e "\n==========================="
echo -e "CHOOSE ONE OR MULTIPLE XIVs"
echo -e "===========================\n"

awk '$1 == "'$SITE'" {print substr($0, index($0,$2))}' $INVF | awk '{print NR ".\t" $0}'

echo -en "\nType the XIV Numbers separated by space:> "
read xivn

#
# check if correct XIV numbers are chosen
# and eliminate duplicates
#
for recnx in $xivn
do
#  duplicates
  xivnc=`echo $xivnd | awk '/'"$recnx"'/'`
  if [[ -z $xivnc ]]
  then
    xivnd="$xivnd $recnx"
#  incorrect XIV numbers
    XIV_line=`awk '$1 == "'$SITE'" {print substr($0, index($0,$2))}' $INVF | awk 'NR == '$recnx' {print $0}'`
    if [[ -z $XIV_line ]]
    then
      incorx="$incorx $recnx"
    fi
  fi

done

if [[ -n $incorx ]]
then
  echo -e "\nIncorrect XIV Number/s: $incorx"
  echo -e "Try Again\n"
  exit 0
fi

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

COMM="ups_list -t component_id,status,currently_functioning,battery_charge_level,runtime_remaining,predictive_remaining_runtime"

echo -e "*****  SITE: $SITE  *****\n*****  RUNNING: $COMM  *****\n"

for recnx in $xivnd
do

 XIV_line=`awk '$1 == "'$SITE'" {print substr($0, index($0,$2))}' $INVF | awk 'NR == '$recnx' {print $0}'`

 HOSTN=`echo $XIV_line | awk '{print $1}'`
 SERN=`echo $XIV_line | awk '{print $2}'`
 HOSTIP=`echo $XIV_line | awk '{print $3}'`

 echo -e "           $HOSTN-$SERN ($HOSTIP)"
### Add your code below ###

 $XCLI -m $HOSTIP -u $USER -p $PW $COMM

### End of your code ###

 echo

done

echo

exit 0
