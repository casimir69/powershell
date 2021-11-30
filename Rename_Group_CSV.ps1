<#
.SYNOPSIS
        Ce script Powershell permet de renommer en masse des groupes Active Directory
	
.DESCRIPTION
	Ce script Powershell va renommer des groupes AD en se basant sur un fichier ".csv" en entrée ($OldName,$NewName,$Description)

.NOTES
	Ce script a besoin d'avoir des privilèges sur le domaine sur lequel on intervient
#>

$ImportGroups = Import-Csv "RenameGroups.csv"

foreach ($Group in $ImportGroups)
{
    $OldName = $Group.OldName
    $NewName = $Group.NewName
    $NewDescription = $Group.NewDescription
    $GroupInAD = Get-ADGroup $Group.OldName
	
    try
   {
        "In try: working on $OldName"
        Set-ADGroup -Identity $GroupInAD -SamAccountName $NewName -Description $Group.NewDescription
        Rename-ADObject -Identity $GroupInAD -NewName $NewName
        Write-Output ($OldName + " has been renamed to " + $NewName)
    }

    catch
    {
	"in Catch for $TempOldName"
        Write-Output "Error: $_"
    }
}
