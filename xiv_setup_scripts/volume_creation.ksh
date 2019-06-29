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

# volume and pool size (GB)
# 3 TB disks: vols=4852, pools=243392
# 3 TB disks, 11 modules: vols=4852, pools=168347
# 4 TB disks: vols=6504, pools=325458
# 4 TB disks, 11 modules: vols=6504, pools=225134
vols=4852
pools=168347

# XIV VPN IP addresses from IP master sheet
### vpn1=146.89.142.247
### vpn2=146.89.142.248

# Please confirm Pool names are correct
VOLB="$site"_"$nn""$zone"_xiv_"$Instance_No"_bb$bblock
POOL="$VOLB"_1

# Do not touch below line
 ip=146.89.142.244


###echo "set vpn ip adresses"
###$preview xcli -m $ip -u $user -p $pw ipinterface_update ipinterface=VPN address=$vpn1,$vpn2 gateway=146.89.142.1 netmask=255.255.255.0

# testing IP and password
echo
$preview xcli -m $ip -u $user -p $pw config_get name=system_name
echo
echo -n " Press ENTER to continue with the script > "
read ENT

echo -e "\nset storage pool\n"
$preview xcli -m $ip -u $user -p $pw pool_create pool=$POOL size=$pools snapshot_size=0


echo -n " Press ENTER to continue with volumes > "
read ENT

echo -e "\ncreate volumes for $POOL\n"
$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_01
$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_02
$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_03
$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_04
$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_05
$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_06
$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_07
$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_08
$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_09
$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_10
$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_11
$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_12
$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_13
$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_14
$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_15
$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_16
$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_17
$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_18
$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_19
$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_20
$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_21
$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_22
$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_23
$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_24
$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_25
$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_26
$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_27
$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_28
$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_29
$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_30
$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_31
$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_32
$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_33
$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_34
#$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_35
#$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_36
#$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_37
#$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_38
#$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_39
#$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_40
#$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_41
#$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_42
#$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_43
#$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_44
#$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_45
#$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_46
#$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_47
#$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_48
#$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_49
#$preview xcli -m $ip -u $user -p $pw vol_create size=$vols pool=$POOL vol="$VOLB"_50


$preview xcli -m $ip -u $user -p $pw version_get
$preview xcli -m $ip -u $user -p $pw fc_port_list

# This is end of script
