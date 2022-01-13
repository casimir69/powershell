Import-Module ActiveDirectory
[string]$version = "13/01/2022_15:40"
$fqdnDomainName = $(Get-WmiObject -Class Win32_ComputerSystem).Domain
$records = Import-Csv -Path "add_to_dns.csv" -Delimiter ";"
Write-Host ""
Write-Host "################## DEBUT_DU_TRAITEMENT ####################"
Write-Host "#             version : $version                  #"
Write-Host "#      fqdnDomainName : $fqdnDomainName                     #"
Write-Host "#    Attention, pas de guillements dans le fichier .csv   #"
Write-Host "###########################################################"
Write-Host ""

foreach ($record in $records)
    {
    #$exist = Get-DnsServerResourceRecord -Zonename $fqdnDomainName -RRtype A -Name $record.computer -ErrorAction SilentlyContinue
    #Write-Host $exist
    #if ($exist -eq $false)
     #   {
        Write-Host "Ajout DNS - Record A de la machine "$record.computer" en "$record.ip""
        Add-DnsServerResourceRecordA -Name $record.computer -IPv4Address $record.ip -ZoneName $fqdnDomainName -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 1
        #Add-DnsServerResourceRecordPtr -ComputerName "DnsServer" 
      #  }
       # else
        #    {
         #   Write-Host "Machine "$record.computer" est déjà dans le DNS"
          #  }
    }
    Write-Host "#################### FIN_DU_TRAITEMENT ####################"
