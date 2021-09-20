Import-module ActiveDirectory

$group = "CN=LP_P_TaskForce-RebootForce_ACCEPT_PILOTE,OU=Groupes,OU=ADM-GPO,DC="
$listeposte = Get-Content -Path c:\temp\listepdt.txt

(Get-ADGroup $group -Properties member).member.Count

Write-Host "---------------Debut de l'ajout---------------------"
Write-Host $listpdt.Count" postes dans la liste"

Foreach($poste in $listeposte){
    $computer = (Get-ADComputer $poste).DistinguishedName
    if ($computer.MemberOf)
    if (Get-ADGroupMember -Id $group | $_.
    write-host "ajout du poste "$poste
    $pdt = Get-ADComputer $poste | select -ExpandProperty SamAccountName
    Write-Host "ajout du SamAccountName "$pdt
    Add-ADGroupMember -Identity $group -Members $pdt -Server domain.fr #Attention la commande fonctionne avec le SamAccountName du poste et pas avec son name
    }

Write-Host "---------------Fin de l'ajout---------------------"

(Get-ADGroup $group -Properties member).member.Count
