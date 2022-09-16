<#
.DESCRIPTION
	Ce script va renommer des groupes AD en se basant sur un fichier ".csv" en entrée ($OldName,$NewName,$Description)
	Ce script a besoin d'être executé avec des privilèges sur le domaine cible

.AUTHOR
	casimir69
#>

### module ###

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

### variables ###
$ImportGroups = Import-Csv "RenameGroups.csv" -delimiter ";"

### script ###
foreach ($Group in $ImportGroups)
{
    [string]$OldName = $Group.OldName
    [string]$NewName = $Group.NewName
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
