param(
    $NomGroupe = ""
)

If ($NomGroupe -eq "")
{
    $NomGroupe = Read-Host "Quel est le nom du groupe ?"
}

Try
{
    $GroupExists = Get-ADGroup -Identity $NomGroupe
}
Catch
{
    Write-Warning "Le groupe demandé n'existe pas !"
    exit 11
}

Get-ADGroupMember -Identity $NomGroupe -Recursive | Select name, objectClass | Where { $_.objectClass -eq "user" } | Export-Csv -Path C:\Scripts\Export-Members-$NomGroupe.csv -Encoding UTF8 -NoTypeInformation

Write-Host "Le fichier est disponible ici : C:\Scripts\Export-Members-$NomGroupe.csv" -ForegroundColor Green

Exit
