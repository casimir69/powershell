<#
.DESCRIPTION
        Ce script Powershell permet de supprimer des users d'un groupe Active Directory en vérifiant sa présence au préalable
.AUTHOR
	Casimir69
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
$ListeUsers = Import-Csv -Path "\UsersToGroup.csv" -Delimiter ";"

Write-Host "##### Début du script Del_User_From_Group #####"

Foreach ($Ligne IN $ListeUsers)
{
    $UserName = $Ligne.DisplayName
    $TeamGroup = $Ligne.TeamGroup
  
    $DeleteGroup = $ListeUser.DeleteGroup
    $AddGroup1 = $ListeUser.AddGroup1
    $AddGroup2 = $ListeUser.AddGroup2
    $AddGroup3 = $ListeUser.AddGroup3
    $AddGroup4 = $ListeUser.AddGroup4
    $AddGroup5 = $ListeUser.AddGroup5
    $AddGroup6 = $ListeUser.AddGroup6
    $AddGroup7 = $ListeUser.AddGroup7
    $AddGroup8 = $ListeUser.AddGroup8
  
    if ($TeamGroup -contains $UserName)
    {
        Write-host "L'utilisateur "$UserName" est déjà dans le groupe "$TeamGroup
    }
    else
    {
        Add-ADGroupMember
        Write-Host "L'utilisateur $UserName n est pas présent dans le groupe $DeleteGroup"
    }
    if ($DeleteGroup -contains $UserName)
    {
        Remove-AdGroupMember -Identity $DeleteGroup -Members $UserName -Confirm:$false
        Write-host "Suppression de l'utilisateur $UserName du groupe $DeleteGroup" 
    }
}
Write-Host "##### Fin du script Del_User_From_Group #####"
