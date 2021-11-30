<#
.SYNOPSIS
        Ce script Powershell permet de renommer en masse des groupes Active Directory
	
.DESCRIPTION
	Ce script Powershell va renommer des groupes AD en se basant sur un fichier ".csv" en entrée ($OldName,$NewName,$Description)

.NOTES
	Ce script a besoin d'avoir des privilèges sur le domaine sur lequel on intervient
	
.VERSIONNING
	v1.2
#>

$ImportGroups = Import-Csv "RenameGroups.csv" -delimiter ";"

If ( (Get-Module -Name ActiveDirectory -ErrorAction SilentlyContinue) -eq $null )
{
    Try {
        Import-Module ActiveDirectory
    } Catch {
        Write-Error "Unable to load the module" -ErrorAction Continue
        Write-Error $Error[1] -ErrorAction Continue
        Exit 1
    }
}

foreach ($Group in $ImportGroups)
{
    $OldName = $Group.OldName
    $NewName = $Group.NewName
    [string]$NewDescription = $Group.NewDescription
    $GroupInAD = Get-ADGroup -Identity $Group.OldName
	
    try
   {
        Write-Host $OldName + " in transformation..." -ForegroundColor Green
        Set-ADGroup -Identity $GroupInAD -SamAccountName $NewName -Description $NewDescription
        Rename-ADObject -Identity $GroupInAD -NewName $NewName
        Write-Host $OldName + " a été renommé en " + $NewName + "-" + $NewDescription -ForegroundColor Green
        Write-Host "... next ..." -BackgroundColor Yellow
    }

    catch
    {
	"in Catch for $OldName"
        Write-Output "Error: $_"
    }
}
