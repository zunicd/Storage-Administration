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
#
# country code
cc=us
# location code
ll=rd
# site
site=$cc$ll
# pod number
 nn=01
 pp=`echo $nn | awk '{print substr($1,2)}'`
# 3rd octet
oct3=1
# SNMP location
snmpl="SCE+ RTP"
# SNMP communities 
snmpc=sceplusral3igh

# XIV IPs
ip15=146.89.142.244

# testing IP and password
echo
$preview xcli -m $ip15 -u $user -p $pw config_get name=system_name
echo
echo -n " Press ENTER to continue with the script > "
read ENT

echo -e "\nSMTP gateways\n"
$preview xcli -m $ip15 -u $user -p $pw smtpgw_define smtpgw=gw02 address=146.89.$oct3.71 from_address="$site"xiv151ccpl"$pp"@$cc.ibm.com 
 
echo -e "\nSNMP Configuration\n"
$preview xcli -m $ip15 -u $user -p $pw config_set name=snmp_location value="$snmpl"
$preview xcli -m $ip15 -u $user -p $pw config_set name=snmp_contact value="RTP Operations SCE+"
##$preview xcli -m $ip15 -u $user -p $pw config_set name=snmp_community value=$snmpc
##$preview xcli -m $ip15 -u $user -p $pw config_set name=snmp_trap_community value=$snmpc
$preview xcli -m $ip15 -u $user -p $pw config_set name=email_reply_to_address value=scepstor@us.ibm.com
$preview xcli -m $ip15 -u $user -p $pw config_set name=email_sender_address value="$site"xiv151ccpl"$pp"@$cc.ibm.com

echo -e "\nPrimary Contact\n"
$preview xcli -m $ip15 -u $user -p $pw vpd_config_set name=customer.name value="IGS c/o SMARTCLOUD ENTERPRISE PLUS"
$preview xcli -m $ip15 -u $user -p $pw vpd_config_set name=customer.primary_contact.name value="RTP Operations SCE+"
$preview xcli -m $ip15 -u $user -p $pw vpd_config_set name=customer.primary_contact.office_phone value="+1-877-737-3700"
##$preview xcli -m $ip15 -u $user -p $pw vpd_config_set name=customer.primary_contact.mobile_phone value=""
##$preview xcli -m $ip15 -u $user -p $pw vpd_config_set name=customer.primary_contact.email value=icloud@us.ibm.com
##$preview xcli -m $ip15 -u $user -p $pw vpd_config_set name=customer.primary_contact.calling_hours value="0000-2359"
##$preview xcli -m $ip15 -u $user -p $pw vpd_config_set name=customer.primary_contact.time_zone value="US/Eastern"

echo -e "\nSecondary Contact\n"
$preview xcli -m $ip15 -u $user -p $pw vpd_config_set name=customer.secondary_contact.name value="SCE+ Storage Steady State"
##$preview xcli -m $ip15 -u $user -p $pw vpd_config_set name=customer.secondary_contact.email value=scepstor@us.ibm.com
##$preview xcli -m $ip15 -u $user -p $pw vpd_config_set name=customer.secondary_contact.time_zone value="US/Eastern"

echo -e "\nLocation\n"
##$preview xcli -m $ip15 -u $user -p $pw vpd_config_set name=site.name value=Winterthur
###$preview xcli -m $ip15 -u $user -p $pw vpd_config_set name=site.building_location value="Bld#10 R189 G09"
###$preview xcli -m $ip15 -u $user -p $pw vpd_config_set name=site.city value=Grabels
###$preview xcli -m $ip15 -u $user -p $pw vpd_config_set name=site.country value=France

echo -e "\nDestinations and Rules\n"
##$preview xcli -m $ip15 -u $user -p $pw dest_define dest=monitor_a type=SNMP snmp_manager=146.89.$oct3.80
##$preview xcli -m $ip15 -u $user -p $pw dest_define dest=monitor_b type=SNMP snmp_manager=146.89.$oct3.81
##$preview xcli -m $ip15 -u $user -p $pw dest_define dest=scepstor type=EMAIL email_address=scepstor@us.ibm.com
$preview xcli -m $ip15 -u $user -p $pw rule_update rule=monitor_rule min_severity=WARNING dests=monitor_a,monitor_b,scepstor

echo -e "\nTesting Notifications\n"
$preview xcli -m $ip15 -u $user -p $pw custom_event description="test ITNM" severity=MAJOR
$preview xcli -m $ip15 -u $user -p $pw custom_event description="test ITNM" severity=CRITICAL



