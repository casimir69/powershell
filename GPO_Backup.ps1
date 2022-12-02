<#
.DESCRIPTION
        Sauvegarde des GPO  
        le script génère un backup de chacune des GPO existantes ainsi qu'un fichier flag avec la date de la sauvegarde.
.NOTES
        Author: casimir69
#>

#region ##### load module #####
If ($null -eq (Get-Module -Name ActiveDirectory -ErrorAction SilentlyContinue))
{
    Try
    {
        Import-Module ActiveDirectory
    }
    Catch
    {
        Write-Error "Unable to load the module" -ErrorAction Continue
        Write-Error $Error[1] -ErrorAction Continue
        Exit 1
    }
}
#endregion ##### load module #####

#region ##### varaible #####
[datetime]$date = Get-date -format dd-MM-yyyy
[string]$GPOPath = “D:\BACKUP\GPO\$date”               #Définition du chemin de l'export
$WMIPath = "D:\BACKUP\GPO\$date\WMI_Full_Backup.csv"   #Définition du fichier de sauvegarde des filtres WMI
#endregion ##### variable #####

#region ##### main script #####
Backup-Gpo -All -Path $GPOPath #Export des GPO

Get-ADObject -Filter 'objectClass -eq "msWMI-Som"' -Properties "msWMI-Name","msWMI-Parm1","msWMI-Parm2"| Select-Object "msWMI-Name","msWMI-Parm1","msWMI-Parm2"|export-csv $WMIPath -notypeinformation -delimiter ";"   #Export des informations sur les filtres WMI

if (Test-Path "$GPOPath\_backuped_*") #Test de l'existance du flag
{
    #S'il existe, modification de son nom avec la date du jour
    Get-Item "$GPOPath\_backuped_*" |Rename-Item -NewName "_backuped_$date.txt"
}
else 
{
    #S'il n'existe pas, création du flag
    New-Item "$GPOPath\_backuped_$date.txt" -type file
}
#endregion ##### main script #####
