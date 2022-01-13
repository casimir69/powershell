<#
.SYNOPSIS
        Ce script Powershell permet d'ajouter des computer dans un groupe Active Directory
.DESCRIPTION
	Ce script Powershell va ajouter les computer que vous aurez préalablement indiqué dans un fichier .txt dans un groupe Active Directory de votre choix.
	Nous aurons besoin du DN du groupe cible
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

$group = "CN=LP_P_TaskForce-RebootForce_ACCEPT_PILOTE,OU=Groupes,OU=ADM-GPO,DC="
$listeposte = Get-Content -Path c:\temp\listepdt.txt

$nbrposteav = (Get-ADGroup $group -Properties member).member.Count

Write-Host "---------------Debut de l'ajout---------------------"
Write-Host $nbrposte" postes avant la mise à jour"

Foreach($poste in $listeposte){
    $computer = (Get-ADComputer $poste).DistinguishedName
    if ($computer.MemberOf)
    if (Get-ADGroupMember -Id $group | $_.
    write-host "Ajout du poste "$poste
    $pdt = Get-ADComputer $poste | select -ExpandProperty SamAccountName
    Write-Host "Ajout du SamAccountName "$pdt
    Add-ADGroupMember -Identity $group -Members $pdt -Server domain.fr #Attention la commande fonctionne avec le SamAccountName du poste et pas avec son DisplayName
    }

$nbrposteap = (Get-ADGroup $group -Properties member).member.Count
Write-Host $nbrposteap" postes après la mise à jour"
Write-Host "---------------Fin de l'ajout---------------------"
