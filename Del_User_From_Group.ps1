<#
.SYNOPSIS
        Ce script Powershell permet de supprimer des users d'un groupe Active Directory en vérifiant sa présence au préalable
.DESCRIPTION
	Ce script Powershell 
.EXAMPLE
	n/c
.NOTES
	Ce script n'a pas besoin de permissions particulière
#>
$ErrorActionPreference = "Stop"

If ((Get-Module -Name ActiveDirectory -ErrorAction SilentlyContinue) -eq $null)
{
    Try {
        Import-Module ActiveDirectory
    } Catch {
        Write-Error "Unable to load the module" -ErrorAction Continue
        Write-Error $Error[1] -ErrorAction Continue
        Exit 1
    }
}
$ListeUsers = Import-Csv -Path "UsersToGroup.csv" -Delimiter ";"
$GroupBefore = 
$GroupAfter1 = 




ForEach ($User in $ListeUsers)
  {
  $UserDispaly = 
  if ($membersGroup -contains $User)
      {
      Remove-AdGroupMember -Identity $GroupBefore -Members $User -Confirm:$false
      Write-host "Suppression de l'utilisateur "$User" du groupe "$GroupBefore
      }
      else
          {
          Write-Host "L'utilisateur "$User" n est pas présent dans le groupe "$GroupBefore
          }
          
  }
Write-Host "### Fin du script ###"
