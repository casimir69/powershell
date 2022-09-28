<#
.DESCRIPTION
        Sauvegarde des GPO  
        le script génère un fichier log et envoi une notification par mail avec le fichier log en pièce jointe
.NOTES
        Author: casimir69
#>

Import-Module ActiveDirectory

[datetime]$date = Get-date -format dd-MM-yyyy
[string]$GPOPath = “D:\GPOBackups\$date” #Définition du chemin de l'export
$WMIPath = "D:\GPOBackups\$date\WMI_Full_Backup.csv" #Définition du fichier de sauvegarde des filtres WMI

Backup-Gpo -All -Path $GPOPath #Export des GPO

Get-ADObject -Filter 'objectClass -eq "msWMI-Som"' -Properties "msWMI-Name","msWMI-Parm1","msWMI-Parm2"| Select-Object "msWMI-Name","msWMI-Parm1","msWMI-Parm2"|export-csv $WMIPath -notypeinformation -delimiter ";" #Export des informations sur les filtres WMI

if (Test-Path "$GPOPath\_backuped_*") #Test de l'existance du flag
    {
    Get-Item "$GPOPath\_backuped_*" |Rename-Item -NewName "_backuped_$date.txt" #S'il existe, modification de son nom avec la date du jour
    }
    else 
        {
        New-Item "$GPOPath\_backuped_$date.txt" -type file #S'il n'existe pas, création du flag
        }
