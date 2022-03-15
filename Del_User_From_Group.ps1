
Import-Module ActiveDirectory

$GroupBefore = 
$GroupAfter = 
$ListeUsers = import-csv

ForEach ($User in $ListeUsers)
  {
  if ($membersGroup -contains $User)
      {
      Remove-AdGroupMember -Identity $GroupBefore -Members $User -Confirm:$false
      Write-host Suppression de l'utilisateur $User du groupe $GroupBefore
      }
      else
          {
          Write-Host L'utilisateur $User n est pas présent dans le groupe $GroupBefore
          }
          
  }
