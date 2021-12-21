$drives = Get-PSDrive -PSProvider FileSystem

Write-Host --== To Begin ==--
Forearch ($drive in $drives)
  {
  Write-Host Scan "($drive.Name):\"
  Get-Children $drive.Name -Recurse -Force -Include *log4j*.jar -ErrorAction SilentlyContinue
  }
  
  Write-Host --== The End ==--
