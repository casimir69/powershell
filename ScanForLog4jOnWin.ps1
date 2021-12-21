$drives = Get-PSDrive -PSProvider FileSystem

Write-Host --== To Start ==--
Foreach ($drive in $drives)
  {
  $drove = $drive.Name +":\"
  Write-Host "Scan" $drove "volume"
  Get-ChildItem $drove -Recurse -Force -Include *log4j*.jar -ErrorAction SilentlyContinue
  }
    Write-Host --== The End ==--
