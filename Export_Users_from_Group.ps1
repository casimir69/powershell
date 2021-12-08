param(
    $NomGroupe = ""
)

if( $NomGroupe -eq ""){
    $NomGroupe = Read-Host "Quel est le nom du groupe ?"
}

try{
    $GroupExists = Get-ADGroup -Identity $NomGroupe
}
catch{
    Write-Warning "Le groupe demande n'existe pas !"
    exit 11
}

Get-ADGroupMember -Identity $NomGroupe -Recursive | Select name, objectClass | Where { $_.objectClass -eq "user" } | Export-Csv -Path C:\Scripts\Export-Members-$NomGroupe.csv -Encoding UTF8 -NoTypeInformation

Write-Host "Le fichier est disponible ici : C:\Scripts\Export-Members-$NomGroupe.csv" -ForegroundColor Green

Exit
