# Storage-Administration
A collection of storage administration scripts

**health_and inventory_visualization**
* Code List.xlsx
* sce+xiv_info.xlsx
* SCE+XIV_Inventory.xlsx
* XIV_Current_Issues_04042018.xlsx

**tsm_backup_scripts**
* tsm_offsite.ksh

>The script runs on each of multiple TSM servers. It checks randomly for the token on other servers in the loop and if it does not see the token, it creates the token itself and starts ejecting tapes. Once all tapes are ejected, it deletes the token and allows other servers to take the token and eject their tapes.
A dummy TSM script represents a token.

