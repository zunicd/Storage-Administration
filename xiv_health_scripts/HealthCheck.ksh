#!/usr/bin/ksh 
#
# XIV health check 
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
LOCAL_DIR=$BASE_DIR/local_out
# comment out the following line (LOG=GSA) for local drive
# uncomment it for GSA drive
#LOG=GSA
# default user
DEFUSER=us2d9999
 
# END of adjustment part

GSA_DIR=/gsa/pokgsa/projects/s/sce-plus/XIV/HealthChecks

ATIME=00:00:00
MIN_SEVERITY=warning

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

#
# check existence of log directory
#
if [[ $LOG = GSA ]]
then
  LOG_DIR=$GSA_DIR/$SITE
else
  LOG_DIR=$LOCAL_DIR
fi

if [[ ! -d $LOG_DIR ]]
then
  echo "$LOG_DIR does not exist!!!!"
  exit 2
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

#Get the current date 
DayOfWeek=`date -u +%a`
TDATE=`date -u +%m/%d/%Y`

DAY_DELTA=1
if [[ $DayOfWeek = Sun ]]
then
   DAY_DELTA=2
fi

if [[ $DayOfWeek = Mon ]]
then
   DAY_DELTA=3
fi

AD=`date -u +%Y-%m-%d --date=''"$DAY_DELTA"' day ago'`
AFTER_DATE=$AD.$ATIME

LOG_FILE=$LOG_DIR/"$SITE"_XIV_log_$DayOfWeek.txt
LOG_FILE1=$LOG_DIR/"$SITE"_XIV_log_"$DayOfWeek"_w1.txt
LOG_FILE2=$LOG_DIR/"$SITE"_XIV_log_"$DayOfWeek"_w2.txt
LOG_FILE3=$LOG_DIR/"$SITE"_XIV_log_"$DayOfWeek"_w3.txt

if [[ -a $LOG_FILE3 ]]
then
   rm $LOG_FILE3
fi

if [[ -a $LOG_FILE2 ]]
then
   mv $LOG_FILE2 $LOG_FILE3
fi

if [[ -a $LOG_FILE1 ]]
then
   mv $LOG_FILE1 $LOG_FILE2
fi

if [[ -a $LOG_FILE ]]
then
   mv $LOG_FILE $LOG_FILE1
fi

fname=`basename $0 .ksh`
ftime=`date +%H%M%S`
tmpf=$fname"_"$ftime.tmp

awk '$1 == "'$SITE'" {print substr($0, index($0,$2))}' $INVF > $HOST_DIR/$tmpf

exec 4<$HOST_DIR/$tmpf
while read -u4 HOSTN SERN HOSTIP MODEL
do

  echo -e "\n\n\n***************************************************************************************" >> $LOG_FILE
  echo "              Checkout for host $HOSTN-$SERN ($HOSTIP)" >> $LOG_FILE
  echo -e "***************************************************************************************\n" >> $LOG_FILE

  echo "Output of component_service_required_list command:" >> $LOG_FILE
  $XCLI -u $USER -p $PW -m $HOSTIP component_service_required_list >> $LOG_FILE
  echo >> $LOG_FILE

  echo "The events with a minumum severity of $MIN_SEVERITY that have been logged since $AFTER_DATE:" >> $LOG_FILE
  $XCLI -u $USER -p $PW -m $HOSTIP event_list after=$AFTER_DATE min_severity=$MIN_SEVERITY >> $LOG_FILE
  echo >> $LOG_FILE

  echo "Output of module_list command:" >> $LOG_FILE
  NMODS=`$XCLI -u $USER -p $PW -m $HOSTIP module_list | tee -a $LOG_FILE | grep -c Module`
  echo >> $LOG_FILE

  if [[ $MODEL = 3 ]]
  then
    echo "Output of serial_consoles_list command:" >> $LOG_FILE
    $XCLI -u $USER -p $PW -m $HOSTIP serial_consoles_list >> $LOG_FILE
    echo >> $LOG_FILE

    echo "Output of ib_port_list command:" >> $LOG_FILE
    $XCLI -u $USER -p $PW -m $HOSTIP ib_port_list >> $LOG_FILE
    echo >> $LOG_FILE
  fi

  echo "Output of ups_list command:" >> $LOG_FILE
  $XCLI -u $USER -p $PW -m $HOSTIP ups_list >> $LOG_FILE
  echo >> $LOG_FILE

  echo "Output of ats_list command:" >> $LOG_FILE
  $XCLI -u $USER -p $PW -m $HOSTIP ats_list >> $LOG_FILE
  echo >> $LOG_FILE

  echo "Output of psu_list command (filters only failed PSUs):" >> $LOG_FILE
  $XCLI -u $USER -p $PW -m $HOSTIP psu_list | awk '$2 !~ /OK/ || $3 !~ /yes/ || $4 !~ /OK/ {print $0}' >> $LOG_FILE
  echo >> $LOG_FILE

  if [[ -a $BASE_DIR/temp_list2.txt ]]
  then
    rm $BASE_DIR/temp_list2.txt
  fi

  echo "Output of the host_connectivity_list command:" >> $LOG_FILE
  $XCLI -u $USER -p $PW -m $HOSTIP host_connectivity_list > $BASE_DIR/host_connectivity_list_output.txt
  sort -o $BASE_DIR/temp_list.txt $BASE_DIR/host_connectivity_list_output.txt

# calculate expected number of paths
# NMODS - number of modules
# AMODS - number of active modules
#
  if [[ $NMODS -eq 9 || $NMODS -eq 10 ]]
  then
    AMODS=4
  elif [[ $NMODS -eq 11 || $NMODS -eq 12 ]]
  then
    AMODS=5
  else
    AMODS=6
  fi

  ((EXPECTED_COUNT=AMODS * 4))

  COUNTER=0
  OLD_COUNTER=0

  exec 5<$BASE_DIR/temp_list.txt
  while read -u5 ts1 ts2
  do

    TEST_STRING=$ts1
    REST_OF_LINE=$ts2
    if [[ $TEST_STRING = Host ]]
    then
      echo "Seq.	$TEST_STRING	$REST_OF_LINE" >> $LOG_FILE
    else
      if [ $COUNTER -eq 0 ]
      then
        HOST=$TEST_STRING
        ((COUNTER=COUNTER+1))
      else
        if [[ $HOST = $TEST_STRING ]]
        then
          ((COUNTER=COUNTER+1))
          OLD_COUNTER=$COUNTER
          OLD_TEST_STRING=$TEST_STRING
          OLD_REST_OF_LINE=$REST_OF_LINE
        else
          COUNTER=1
          HOST=$TEST_STRING
          if [ $OLD_COUNTER -eq $EXPECTED_COUNT ]
          then
            echo "$OLD_COUNTER	$OLD_TEST_STRING	$OLD_REST_OF_LINE" >> $LOG_FILE
          else
            exec 6<$BASE_DIR/temp_list2.txt
            while read -u6 line
            do
              LINE=$line
              echo "$LINE" >> $LOG_FILE
            done
          fi

          if [[ -a $BASE_DIR/temp_list2.txt ]]
          then
            rm $BASE_DIR/temp_list2.txt
          fi
          echo "---------------------------------------------------------------------------------------" >> $LOG_FILE
        fi  
      fi
    echo "$COUNTER	$TEST_STRING	$REST_OF_LINE" >> $BASE_DIR/temp_list2.txt
    fi

  done

if [ $OLD_COUNTER -eq $EXPECTED_COUNT ]
then
  echo "$OLD_COUNTER	$OLD_TEST_STRING	$OLD_REST_OF_LINE" >> $LOG_FILE
else
  exec 6<$BASE_DIR/temp_list2.txt
  while read -u6 line
  do
    LINE=$line
    echo "$LINE" >> $LOG_FILE
  done
fi

echo "---------------------------------------------------------------------------------------" >> $LOG_FILE

done

if [[ -a $BASE_DIR/temp_list.txt ]]
then
  rm $BASE_DIR/temp_list.txt
fi

if [[ -a $BASE_DIR/temp_list2.txt ]]
then
  rm $BASE_DIR/temp_list2.txt
fi

if [[ -a $BASE_DIR/host_connectivity_list_output.txt ]]
then
  rm $BASE_DIR/host_connectivity_list_output.txt
fi

if [[ -a $HOST_DIR/$tmpf ]]
then
  rm $HOST_DIR/$tmpf
fi

echo "XIV Health Check for $SITE - END"

exit 0
