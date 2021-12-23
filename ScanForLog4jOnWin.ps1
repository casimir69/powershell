$execDateTime = Get-Date
$localComputerName = $(Get-WmiObject -Class Win32_ComputerSystem).Name
$fqdnDomainName = $(Get-WmiObject -Class Win32_ComputerSystem).Domain
$fqdnLocalComputer = $localComputerName + "." + $fqdnDomainName
$scriptFullPath = $MyInvocation.MyCommand.Definition
$drives = Get-PSDrive -PSProvider FileSystem
$logfile = ("C:\Temp\ScanForLog4jOnWin_"+ $localComputerName +"_"+(Get-date -Format 'yyyy-MM-dd')+".log")

Clear-Content $logfile

Add-Content $logfile "Début du script..................."
Add-Content $logfile ".................................."
Add-Content $logfile "Date/Time.........................: $execDateTime"
Add-Content $logfile "Local Computer....................: $fqdnLocalComputer"
Add-Content $logfile "Domain Name.......................: $fqdnDomainName"
Add-Content $logfile "Script Full Path..................: $scriptFullPath"
Add-Content $logfile ".................................."

Foreach ($drive in $drives)
  {
  [string]$drove = $drive.Name +':\'
  Add-Content $logfile "Scan $drove"
  Get-ChildItem $drove -Recurse -Force -Include *log4j*.jar -ErrorAction SilentlyContinue | Add-Content $logfile
  }
  Add-Content $logfile "Fin du script...................."

  Move-Item -Path $logfile -Destination \\$fqdnDomainName\SYSVOL\$fqdnDomainName\scripts\Log4j\
