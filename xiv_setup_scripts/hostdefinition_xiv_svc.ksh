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
# pod number
 nn=01
 pp=`echo $nn | awk '{print substr($1,2)}'`


# POD1 SVC#1 node1-8 WWNN Last 5 digit
 svc1p1fc=0:C5:6D
 svc1p2fc=0:C5:BF
 svc1p3fc=0:D0:29
 svc1p4fc=0:C7:CD
 svc1p5fc=0:F1:17
 svc1p6fc=0:F0:E4
 svc1p7fc=0:F0:E7
 svc1p8fc=0:F1:67

# Do not touch below line
 ip15p=146.89.142.244

 svc1p="$site"svc011ccpl$pp

# testing IP and password
echo
$preview xcli -m $ip15p -u $user -p $pw config_get name=system_name
echo
echo -n " Press ENTER to continue with the script > "
read ENT

# hostdefinition xiv15p
echo -e "\ncreate cluster and define hosts\n"

$preview xcli -m $ip15p -u $user -p $pw cluster_create cluster=$svc1p
$preview xcli -m $ip15p -u $user -p $pw host_define host=svc01a cluster=$svc1p
$preview xcli -m $ip15p -u $user -p $pw host_define host=svc02a cluster=$svc1p
$preview xcli -m $ip15p -u $user -p $pw host_define host=svc03a cluster=$svc1p
$preview xcli -m $ip15p -u $user -p $pw host_define host=svc04a cluster=$svc1p
$preview xcli -m $ip15p -u $user -p $pw host_define host=svc05a cluster=$svc1p
$preview xcli -m $ip15p -u $user -p $pw host_define host=svc06a cluster=$svc1p
$preview xcli -m $ip15p -u $user -p $pw host_define host=svc07a cluster=$svc1p
$preview xcli -m $ip15p -u $user -p $pw host_define host=svc08a cluster=$svc1p

echo -e "\nadd ports\n"
$preview xcli -m $ip15p -u $user -p $pw host_add_port host=svc01a fcaddress=50:05:07:68:01:1$svc1p1fc
$preview xcli -m $ip15p -u $user -p $pw host_add_port host=svc01a fcaddress=50:05:07:68:01:2$svc1p1fc
$preview xcli -m $ip15p -u $user -p $pw host_add_port host=svc01a fcaddress=50:05:07:68:01:3$svc1p1fc
$preview xcli -m $ip15p -u $user -p $pw host_add_port host=svc01a fcaddress=50:05:07:68:01:4$svc1p1fc
echo
$preview xcli -m $ip15p -u $user -p $pw host_add_port host=svc02a fcaddress=50:05:07:68:01:1$svc1p2fc
$preview xcli -m $ip15p -u $user -p $pw host_add_port host=svc02a fcaddress=50:05:07:68:01:2$svc1p2fc
$preview xcli -m $ip15p -u $user -p $pw host_add_port host=svc02a fcaddress=50:05:07:68:01:3$svc1p2fc
$preview xcli -m $ip15p -u $user -p $pw host_add_port host=svc02a fcaddress=50:05:07:68:01:4$svc1p2fc
echo
$preview xcli -m $ip15p -u $user -p $pw host_add_port host=svc03a fcaddress=50:05:07:68:01:1$svc1p3fc
$preview xcli -m $ip15p -u $user -p $pw host_add_port host=svc03a fcaddress=50:05:07:68:01:2$svc1p3fc
$preview xcli -m $ip15p -u $user -p $pw host_add_port host=svc03a fcaddress=50:05:07:68:01:3$svc1p3fc
$preview xcli -m $ip15p -u $user -p $pw host_add_port host=svc03a fcaddress=50:05:07:68:01:4$svc1p3fc
echo
$preview xcli -m $ip15p -u $user -p $pw host_add_port host=svc04a fcaddress=50:05:07:68:01:1$svc1p4fc
$preview xcli -m $ip15p -u $user -p $pw host_add_port host=svc04a fcaddress=50:05:07:68:01:2$svc1p4fc
$preview xcli -m $ip15p -u $user -p $pw host_add_port host=svc04a fcaddress=50:05:07:68:01:3$svc1p4fc
$preview xcli -m $ip15p -u $user -p $pw host_add_port host=svc04a fcaddress=50:05:07:68:01:4$svc1p4fc
echo
$preview xcli -m $ip15p -u $user -p $pw host_add_port host=svc05a fcaddress=50:05:07:68:01:1$svc1p5fc
$preview xcli -m $ip15p -u $user -p $pw host_add_port host=svc05a fcaddress=50:05:07:68:01:2$svc1p5fc
$preview xcli -m $ip15p -u $user -p $pw host_add_port host=svc05a fcaddress=50:05:07:68:01:3$svc1p5fc
$preview xcli -m $ip15p -u $user -p $pw host_add_port host=svc05a fcaddress=50:05:07:68:01:4$svc1p5fc
echo
$preview xcli -m $ip15p -u $user -p $pw host_add_port host=svc06a fcaddress=50:05:07:68:01:1$svc1p6fc
$preview xcli -m $ip15p -u $user -p $pw host_add_port host=svc06a fcaddress=50:05:07:68:01:2$svc1p6fc
$preview xcli -m $ip15p -u $user -p $pw host_add_port host=svc06a fcaddress=50:05:07:68:01:3$svc1p6fc
$preview xcli -m $ip15p -u $user -p $pw host_add_port host=svc06a fcaddress=50:05:07:68:01:4$svc1p6fc
echo
$preview xcli -m $ip15p -u $user -p $pw host_add_port host=svc07a fcaddress=50:05:07:68:01:1$svc1p7fc
$preview xcli -m $ip15p -u $user -p $pw host_add_port host=svc07a fcaddress=50:05:07:68:01:2$svc1p7fc
$preview xcli -m $ip15p -u $user -p $pw host_add_port host=svc07a fcaddress=50:05:07:68:01:3$svc1p7fc
$preview xcli -m $ip15p -u $user -p $pw host_add_port host=svc07a fcaddress=50:05:07:68:01:4$svc1p7fc
echo
$preview xcli -m $ip15p -u $user -p $pw host_add_port host=svc08a fcaddress=50:05:07:68:01:1$svc1p8fc
$preview xcli -m $ip15p -u $user -p $pw host_add_port host=svc08a fcaddress=50:05:07:68:01:2$svc1p8fc
$preview xcli -m $ip15p -u $user -p $pw host_add_port host=svc08a fcaddress=50:05:07:68:01:3$svc1p8fc
$preview xcli -m $ip15p -u $user -p $pw host_add_port host=svc08a fcaddress=50:05:07:68:01:4$svc1p8fc

# This is end of script
