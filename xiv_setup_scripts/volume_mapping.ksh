#
# Ask the preview question
#
echo -e " For preview type yes or y [default=yes]\n For execution type x "
read answer
answer=`echo $answer | awk '{print toupper($1)}'`

if [[ $answer = YES || $answer = Y  || $answer = "" ]]
then
   preview=echo
   user=dummy
   pw=dummy
elif [[ $answer = X ]]
then
   preview=""
# default user
   DEFUSER=us2d9999
   echo -n "Enter username [$DEFUSER]:> "
   read user
   [[ -z $user ]] && user=$DEFUSER
   #uncomment the line below if you do not want pw to be seen when you are typing
   #stty -echo
   echo -n "Enter password for $user:> "
   read pw
   stty echo
   echo
else
   echo " Wrong answer !!!!"
   exit 33
fi


# Installation Site
site=usrd

# Server Instance Number
 Instance_No=15

# pod number
 nn=01
 pp=`echo $nn | awk '{print substr($1,2)}'`

# zone (a or b)
zone=a

# Building Block (1 or 2)
bblock=1

# volume size (GB)
# 3 TB diss: vols=4852
# 4 TB disks: vols=6504
vols=4852

# Please confirm Pool names are correct
VOLB="$site"_"$nn""$zone"_xiv_"$Instance_No"_bb$bblock
POOL="$VOLB"_1

# Do not touch below line
svc1p="$site"svc011ccpl"$pp"
ip=146.89.142.244

# testing IP and password
echo
$preview xcli -m $ip -u $user -p $pw config_get name=system_name
echo
echo -n " Press ENTER to continue with the script > "
read ENT

echo "Mapping Volume POD $pp XIV $Instance_No"
echo -e "\nMapping Volumes in the pool $POOL\n"
$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_01 lun=1
$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_02 lun=2
$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_03 lun=3
$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_04 lun=4
$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_05 lun=5
$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_06 lun=6
$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_07 lun=7
$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_08 lun=8
$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_09 lun=9
$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_10 lun=10
$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_11 lun=11
$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_12 lun=12
$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_13 lun=13
$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_14 lun=14
$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_15 lun=15
$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_16 lun=16
$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_17 lun=17
$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_18 lun=18
$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_19 lun=19
$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_20 lun=20
$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_21 lun=21
$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_22 lun=22
$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_23 lun=23
$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_24 lun=24
$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_25 lun=25
$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_26 lun=26
$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_27 lun=27
$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_28 lun=28
$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_29 lun=29
$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_30 lun=30
$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_31 lun=31
$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_32 lun=32
$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_33 lun=33
$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_34 lun=34
#$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_35 lun=35
#$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_36 lun=36
#$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_37 lun=37
#$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_38 lun=38
#$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_39 lun=39
#$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_40 lun=40
#$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_41 lun=41
#$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_42 lun=42
#$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_43 lun=43
#$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_44 lun=44
#$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_45 lun=45
#$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_46 lun=46
#$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_47 lun=47
#$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_48 lun=48
#$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_49 lun=49
#$preview xcli -m $ip -u $user -p $pw map_vol cluster=$svc1p vol="$VOLB"_50 lun=50


$preview xcli -m $ip -u $user -p $pw mapping_list cluster=$svc1p

# This is end of script
