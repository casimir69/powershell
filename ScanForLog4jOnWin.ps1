$execDateTime = Get-Date
$localComputerName = $(Get-WmiObject -Class Win32_ComputerSystem).Name
$fqdnDomainName = $(Get-WmiObject -Class Win32_ComputerSystem).Domain
$fqdnLocalComputer = $localComputerName + "." + $fqdnDomainName
$scriptFullPath = $MyInvocation.MyCommand.Definition
$cmdLineUsed = $MyInvocation.Line
$drives = Get-PSDrive -PSProvider FileSystem
$DateTime = Get-date -Format "[dd/MM/yyyy][HH:mm:ss]"

$logfile = $scriptFullPath\ScanForLog4jOnWin.log
Clear-Content $logfile

Function LogWrite
{
   Param ([string]$logstring)

   Add-content $logfile -value $logstring
}

LogWrite ""
LogWrite "Date/Time   ......................: $execDateTime"
LogWrite "Local Computer....................: $fqdnLocalComputer"
LogWrite ""
LogWrite "Script Full Path..................: $scriptFullPath"
LogWrite "Script Command Line Used..........: $cmdLineUsed"
LogWrite ""
LogWrite "Start Script in "$fqdnLocalComputer""

Foreach ($drive in $drives)
  {
  $drove = $drive.Name +":\"
  LogWrite "Scan" $drove "volume"
  #Get-ChildItem $drove -Recurse -Force -Include regedit.exe -ErrorAction SilentlyContinue
  Get-ChildItem $drove -Recurse -Force -Include *log4j*.jar -ErrorAction SilentlyContinue
  }
  
  LogWrite "The End"
