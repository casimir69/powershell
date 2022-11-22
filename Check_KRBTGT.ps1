<#
.DESCRIPTION
        Check pwdLastSet date for krbtgt account (less than 6 month)
        Verify in Ping Castle software if more than 365 days

.AUTHOR
        casimir69
#>

##### module #####
If ($null -eq (Get-Module -Name ActiveDirectory -ErrorAction SilentlyContinue))
{
    Try
    {
        Import-Module ActiveDirectory
    }
    Catch
    {
        Write-Error "Unable to load the module" -ErrorAction Continue
        Write-Error $Error[1] -ErrorAction Continue
        Exit 1
    }
}

##### variable #####
[string]$scriptVersion = "v20220919"
[string]$domain = $env:USERDOMAIN
[bool]$mailreport = 0            #1 or 0 or True or False
[string]$env = MQT               #PROD or MQT
[string]$currentDate = (Get-Date).Date.AddDays(-180).ToFileTime()
[string]$logfile = "$PSScriptRoot\Check_KRBTGT_"+ $domain +".log"
$accounts = Get-ADUser -Filter * -Properties Name, ServicePrincipalName, pwdLastSet, PasswordLastSet | Where-Object {$_.ServicePrincipalName -Like "kadmin/changepw"}

Add-Content $logfile "[$(Get-Date -Format "dd/MM/yyyy_HH:mm:ss")] ### Début du script Check_KRBTGT.ps1 - $scriptVersion ###"
Write-Host "[$(Get-Date -Format "dd/MM/yyyy_HH:mm:ss")] ### Début du script Check_KRBTGT.ps1 - $scriptVersion ###"

##### fonction #####
Function Mail
{
    param(
        [parameter()]
        [string]$subject,
        [string]$body
    )
    [string]$mailEncoding = "UTF8"
    [string]$smtpServer = "IP"
    [int]$port = "25"
    [string]$from = "Check_$domain@domain.fr"
    [string]$to =  "mailTo@domain.fr"
    [string]$bcc = "mailBcc@domain.fr"

    Add-Content $logfile "[$(Get-Date -Format "dd/MM/yyyy_HH:mm:ss")] Sendind Report Email from $from to $to"
    Write-Host "[$(Get-Date -Format "dd/MM/yyyy_HH:mm:ss")] Sendind Report Email from $from to $to"

    Send-MailMessage -SmtpServer $smtpServer -Port $port -From $from -To $to -Bcc $bcc -Subject $subject -Body $body -bodyasHTML -Attachments $logfile -Encoding $mailEncoding
}

##### script #####
foreach ($krbtgt IN $accounts)
{
    [string]$kname = $krbtgt.Name
    [Datetime]$kpls = $krbtgt.PasswordLastSet

    if ($krbtgt.pwdLastSet -lt $currentDate)
    {
        Add-Content $logfile "[$(Get-Date -Format "dd/MM/yyyy_HH:mm:ss")] Il faut renouveler le password du compte $kname d'$domain qui date du $kpls (US date)"
        Write-Host "[$(Get-Date -Format "dd/MM/yyyy_HH:mm:ss")] Il faut renouveler le password du compte $kname d'$domain qui date du $kpls (US date)" -BackgroundColor DarkRed
        if ($mailreport -eq true)
        {
            Mail "[$env][$domain] Compte krbtgt : Renouvellement du mot de passe" "Le mot de passe du compte krbtgt du domaine $domain.edf.fr a plus de 6 mois ($kpls US date), il faut le renouveller !"
        }
    }
    else
    {
        Add-Content $logfile "[$(Get-Date -Format "dd/MM/yyyy_HH:mm:ss")] Le mot de passe du compte $kname a moins de 6 mois"
        Write-host "[$(Get-Date -Format "dd/MM/yyyy_HH:mm:ss")] Le mot de passe du compte $kname a moins de 6 mois"
    }
}
Add-Content $logfile "[$(Get-Date -Format "dd/MM/yyyy_HH:mm:ss")] ### Fin du script Check_KRBTGT.ps1 ###"
Write-Host "[$(Get-Date -Format "dd/MM/yyyy_HH:mm:ss")] ### Fin du script Check_KRBTGT.ps1 ###"
