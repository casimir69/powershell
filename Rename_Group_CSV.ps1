#
#    Rename_Group_CSV.ps1
#

$ImportGroups = Import-Csv "RenameGroups.csv"

foreach ($Group in $ImportGroups)
{
    $OldName = $Group.OldName
    $NewName = $Group.NewName
    $GroupInAD = Get-ADGroup $Group.OldName
	
    try
   {
        "In try: working on $OldName"
        Set-ADGroup -Identity $GroupInAD -SamAccountName $NewName
        Rename-ADObject -Identity $GroupInAD -NewName $NewName
        Write-Output ($OldName + " has been renamed to " + $NewName)
    }

    catch
    {
	"in Catch for $TempOldName"
        Write-Output "Error: $_"
    }
}
