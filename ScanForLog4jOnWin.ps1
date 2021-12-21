$drives = Get-PSDrive -PSProvider FileSystem

Write-Host --== To Begin ==--
Forearch ($drive in $drives)
  {
  $drove = $drive.Name +":\"
  Write-Host "Scan"+ $drove +"volume"
  Get-Children $drove -Recurse -Force -Include *log4j*.jar -ErrorAction SilentlyContinue
  }
  
  Write-Host --== The End ==--
