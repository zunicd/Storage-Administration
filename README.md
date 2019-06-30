# Storage-Administration
A collection of storage administration scripts

**health_and inventory_visualization**
* _Code List.xlsx_ - Microcode inventory
* _sce+xiv_info.xlsx_ - XIV inventory with additional info with one site per tab - long format
* _SCE+XIV_Inventory.xlsx_ - XIV inventory for all sites, one tab - short format
* _XIV_Current_Issues_04042018.xlsx_ - worksheet for listing and monitoring all HW issues and following them until resolution; history repository for all previous issues

**tsm_backup_scripts**
* _tsm_offsite.ksh_ - The script runs on each of multiple TSM servers. It checks randomly for the token on other servers in the loop and if it does not see the token, it creates the token itself and starts ejecting tapes. Once all tapes are ejected, it deletes the token and allows other servers to take the token and eject their tapes.
A dummy TSM script represents a token.

**xiv_health_scripts**
* _HealthCheck.ksh_ – health check script
* _SaveConfigs.ksh_ – configuration saving script
* _SaveConfigs_mXIV.ksh_ – configuration saving script for one or multiple XIVs
* _PreChangeBackup.ksh_ – pre change backup script
* _PreChangeBackup_mXIV.ksh_ – pre change backup script for one or multiple XIVs
* _xcli_comm.ksh_ – executing an xcli command for all XIVs in one site
* _xcli_comm_mXIV.ksh_ – executing an xcli command for one or multiple XIVs
* _xcli_start.ksh_ – starting xcli session 
* _XIV Scripts for Linux.docx_

***Note:*** SaveConfigs scripts are using HAK (IBM Storage Host Attachment Kit) for Linux and xiv_save_config, a python script developed by Gil Sharon (gil@us.ibm.com). They should be installed in the folder TOOLS.

**xiv_report_scripts**
* _Device list script.docx_
* _Device List Script.mov_
*	_device_list.ksh_ - lists all devices, IPs and serial numbers for the chosen site in a second
*	_xcli_comm.ksh_ – executing an xcli command for all XIVs in one site
*	_xcli_comm_mXIV.ksh_ – executing an xcli command for one or multiple XIVs
*	_xcli_ups.ksh_ - running an XIV ups_list with custom parameters on all XIVs in one site
*	_xcli_ups_mXIV.ksh_ - running an XIV ups_list with custom parameters for one or multiple XIVs
*	_XIV Report Scripts.mov_

***Note:*** The `xcli_comm` scripts will ask you to enter the command and then they will process it. This is good for simple and short commands. The `xcli_ups` scripts can be used as templates. This is good for long commands or set of commands that need to be executed more frequently. For a particular activity you create the script by hard coded the commands in the basic script template. The scripts could be easily adapted for different commands and for other devices. For XIVs only part where the commands are listed need to be changed, and for other devices few more things. 


**xiv_setup_scripts**
* _hostdefinition_xiv_svc.ksh_
* _misc_config.ksh_
* _volume_creation.ksh_
* _volume_mapping.ksh_
* _XIV setup scripts.docx_

***Note:*** These scripts are mostly a list of numerous cli commands. In scripts for logical add of storage I am using a `preview mode` to make sure that everything is correct. The script will substitute all variables and list all commands exactly the same way they will be executed. This is a good way to check the scripts before real execution. The same idea could be used for other devices as well. 


**xiv_wiki**
* _XIV Wiki Pages.docx_
* _XIV Wiki.mov_

