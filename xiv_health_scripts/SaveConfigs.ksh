#!/usr/bin/ksh 
#
# Saving XIV configuration for all XIVs in one site
#
# February/12/2014 Damir Zunic
#
# adjust the following lines for your environment
# $HOME is home directory environment variable
# for example: /home/dzunic
#
BASE_DIR=$HOME/XIV/XIVscripts
TOOLS_DIR=$BASE_DIR/TOOLS
XPYV=$TOOLS_DIR/HAK/xpyv/bin/xpyv
XIV_SAVE_CONFIG=$TOOLS_DIR/xiv_save_config/xiv_save_config.py
HOST_DIR=$BASE_DIR/host_lists
SITEF=$HOST_DIR/SITES.txt
INVF=$HOST_DIR/xiv_inv.txt
SASGUI_DIR=$HOME/.sasgui
LOCAL_DIR=$BASE_DIR/local_out
# comment out the following line (OUT=GSA) for local drive
# uncomment it for GSA drive
# OUT=GSA
# default user
DEFUSER=us2d9999

# END of adjustment part

GSA_DIR=/gsa/pokgsa/projects/s/sce-plus/XIV/ConfigSaves

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

echo "XIV Backup Config for $SITE - START"

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

#
# check existence of log directory
#
if [[ $OUT = GSA ]]
then
  MONTH=`date -u +%b`
  OUT_DIR=$GSA_DIR/$MONTH
else
  OUT_DIR=$LOCAL_DIR
fi

if [[ ! -d $OUT_DIR ]]
then
  echo "$OUT_DIR does not exist!!!!"
  exit 2
fi

#
# remove previous year files if they exist on GSA drive
#
if [[ $OUT = GSA ]]
then
  PYEAR=`date -u +%Y --date="1 year ago"`
  ls -al $OUT_DIR/*.$PYEAR*.txt > /dev/null 2>&1
  rc=$?
  if [[ $rc -eq 0 ]]
  then
    rm $OUT_DIR/*.$PYEAR*.txt
  fi
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

fname=`basename $0 .ksh`
ftime=`date +%H%M%S`
tmpf=$fname"_"$ftime.tmp

awk '$1 == "'$SITE'" {print substr($0, index($0,$2))}' $INVF > $HOST_DIR/$tmpf

exec 4<$HOST_DIR/$tmpf
while read -u4 HOSTN SERN HOSTIP MODEL
do
  TODAY=`date -u '+%Y%m%d%H%M'`
  $XPYV $XIV_SAVE_CONFIG -u $USER -p $PW -m $HOSTIP -d
  mv *config*.txt $OUT_DIR/$HOSTN.$TODAY.txt
done

if [[ -a $HOST_DIR/$tmpf ]]
then
  rm $HOST_DIR/$tmpf
fi

echo -e "\nXIV Backup Config for $SITE - END"

exit 0
