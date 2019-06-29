#!/usr/bin/ksh
#
# list all devices, IPs and some serial numbers
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
XIVINVF=$HOST_DIR/xiv_inv.txt
SAN_HOST_DIR=$HOME/SCE+/SAN/Scripts
SWINVF=$SAN_HOST_DIR/switch_inv.txt
SVC_HOST_DIR=$HOME/SCE+/SVC/Scripts
SVCINVF=$SVC_HOST_DIR/svc_inv.txt
V7K_HOST_DIR=$HOME/SCE+/V7000/Scripts
V7KINVF=$V7K_HOST_DIR/v7k_inv.txt
FS_HOST_DIR=$HOME/SCE+/FlashSystem/Scripts
FSINVF=$FS_HOST_DIR/fs_inv.txt

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

echo -e "\n*** $FSITE - $SITE ***"

echo -e "=============="
echo -e "     XIVs"
echo -e "=============="

# check XIV existence in the site
grep $SITE $XIVINVF > /dev/null
xivc=$?
if [[ $xivc != 0 ]]
then
  echo -e "There are no XIVs in $SITE\n"
else
  awk '$1 == "'$SITE'" {print substr($0, index($0,$2))}' $XIVINVF | awk '{print NR ".\t" $1 "\t\t" $3 "\t\t" $2}'
fi

echo -e "================="
echo -e "     SAN SWs"
echo -e "================="

awk '$1 == "'$SITE'" {print substr($0, index($0,$2))}' $SWINVF | awk '{print NR ".\t" $1 "\t\t" $2 "\t\t" $3}'

echo -e "=============="
echo -e "     SVCs"
echo -e "=============="

awk '$1 == "'$SITE'" {print substr($0, index($0,$2))}' $SVCINVF | awk '{print NR ".\t" $1 "\t\t" $2}'

echo -e "================"
echo -e "     V7000s"
echo -e "================"

# check v7k existence in the site
grep $SITE $V7K_HOST_DIR/v7k_inv.txt > /dev/null
v7kc=$?
if [[ $v7kc != 0 ]]
then
  echo -e "There are no V7000 in $SITE\n"
else
  awk '$1 == "'$SITE'" {print substr($0, index($0,$2))}' $V7KINVF | awk '{print NR ".\t" $1 "\t\t" $2 "\t\t" $3}'
fi

echo -e "======================"
echo -e "     FlashSystems"
echo -e "======================"

# check FS existence in the site
grep $SITE $FS_HOST_DIR/fs_inv.txt > /dev/null
fsc=$?
if [[ $fsc != 0 ]]
then
  echo -e "There are no FlashSystem in $SITE\n"
else
  awk '$1 == "'$SITE'" {print substr($0, index($0,$2))}' $FSINVF | awk '{print NR ".\t" $1 "\t\t" $2 "\t\t" $3}'
fi

echo

exit 0
