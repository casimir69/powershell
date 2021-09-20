#=============================#
#           Variables         #
#=============================#
Import-Module ActiveDirectory

$date = get-date -format dd-MM-yyyy #Récupération de la date du jour
$GPOPath = “c:\GPOBackups\GPOBackups” #Définition du chemin de l'export
$WMIPath = "C:\GPOBackups\GPOBackups\WMI_Full_Backup.csv" #Définition du fichier de sauvegarde des filtres WMI

Backup-Gpo -All -Path $GPOPath #Exportation des GPOs de production vers le chemin défini

Get-ADObject -Filter 'objectClass -eq "msWMI-Som"' -Properties "msWMI-Name","msWMI-Parm1","msWMI-Parm2"| Select-Object "msWMI-Name","msWMI-Parm1","msWMI-Parm2"|export-csv $WMIPath -notypeinformation -delimiter ";" #Export des informations sur les filtres WMI

if (Test-Path "$GPOPath\_backuped_*") #Test de l'existance du flag
    {
    Get-Item "$GPOPath\_backuped_*" |Rename-Item -NewName "_backuped_$date.txt" #S'il existe, modification de son nom avec la date du jour
    }
    else 
        {
        New-Item "$GPOPath\_backuped_$date.txt" -type file #S'il n'existe pas, création du flag
        }
