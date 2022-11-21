<#
.SYNOPSIS
        Script de desactivation des comptes AL et -A sur le domaine sur lequel vous l'executez
.DESCRIPTION
	
#>
$ErrorActionPreference = "Stop"

If ((Get-Module -Name ActiveDirectory -ErrorAction SilentlyContinue) -eq $null)
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

$Path = Get-Location
$DateTime = Get-Date -Format "[dd/MM/yyyy][HH:mm:ss]"
#================#
#     Corps      #
#================#
Clear-Host

$DateTime | Out-File -FilePath $Path\Disable_LocalAdmin_Account.log -Append

$NbrUsers = Get-ADUser -Filter {Name -like "*_AL" -or Name -like "*-A"} #| Disable-ADAccount
$NbrUsers.Name | Out-File -FilePath $Path\Disable_LocalAdmin_Account.log -Append
echo ([string]$NbrUsers.Count +" comptes") | Out-File -FilePath $Path\Disable_LocalAdmin_Account.log -Append
