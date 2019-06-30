# Storage-Administration
A collection of storage administration scripts

**health_and inventory_visualization**
* _Code List.xlsx_
* _sce+xiv_info.xlsx_
* _SCE+XIV_Inventory.xlsx_
* _XIV_Current_Issues_04042018.xlsx_

**tsm_backup_scripts**
* _tsm_offsite.ksh_ - The script runs on each of multiple TSM servers. It checks randomly for the token on other servers in the loop and if it does not see the token, it creates the token itself and starts ejecting tapes. Once all tapes are ejected, it deletes the token and allows other servers to take the token and eject their tapes.
A dummy TSM script represents a token.

**xiv_health_scripts**
* _HealthCheck.ksh_ – health check script
* _SaveConfigs.ksh_ – configuration saving script
* _SaveConfigs_mXIV.ksh_ – configuration saving script for one or multiple XIVs
* _PreChangeBackup.ksh_ – pre change backup script
* _PreChangeBackup_mXIV.ksh_ – pre change backup script for one or multiple XIVs
* _xcli_comm.ksh – executing_ an xcli command for all XIVs in one site
* ,,xcli_comm_mXIV.ksh,, – executing an xcli command for one or multiple XIVs
* xcli_start.ksh – starting xcli session 
* XIV Scripts for Linux.docx

***Note:*** SaveConfigs scripts are using HAK (IBM Storage Host Attachment Kit) for Linux and xiv_save_config, a python script developed by Gil Sharon (gil@us.ibm.com). They should be installed in the folder TOOLS.

**xiv_report_scripts**
* Device list script.docx
* Device List Script.mov
*	device_list.ksh
*	xcli_comm.ksh
*	xcli_comm_mXIV.ksh
*	xcli_ups.ksh
*	xcli_ups_mXIV.ksh
*	XIV Report Scripts.mov
