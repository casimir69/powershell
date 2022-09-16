<#
.DESCRIPTION
Check pwdLastSet date for krbtgt account (less than 6 month)
Vérifié dans PGC si plus de 365 jours

.AUTEUR
casimir69
#>

Import-Module ActiveDirectory

[string]$version = "v20220916"
[string]$domain = $env:USERDOMAIN
[string]$currentDate = (Get-Date).Date.AddDays(-180).ToFileTime()
[string]$logfile = "$PSScriptRoot\Check_KRBTGT_"+ $domain +".log"
$accounts = Get-ADUser -Filter * -Properties Name, ServicePrincipalName, pwdLastSet, PasswordLastSet | Where-Object {$_.ServicePrincipalName -Like "kadmin/changepw"}

Add-Content $logfile "[$(Get-Date -Format "dd/MM/yyyy_HH:mm:ss")] ### Début du script Check_KRBTGT $version ###"
Write-Host "[$(Get-Date -Format "dd/MM/yyyy_HH:mm:ss")] ### Début du script Check_KRBTGT $version ###"

##### Fonction #####
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
    [string]$env = MQT    #PROD or MQT
    [string]$from = "Check_$domain@domain.fr"
    [string]$to =  "mailTo@domain.fr"
    [string]$bcc = "mailBcc@domain.fr"

    Add-Content $logfile "[$(Get-Date -Format "dd/MM/yyyy_HH:mm:ss")] Sendind Report Email from $from to $to"
    Write-Host "[$(Get-Date -Format "dd/MM/yyyy_HH:mm:ss")] Sendind Report Email from $from to $to"

    Send-MailMessage -SmtpServer $smtpServer -Port $port -From $from -To $to -Bcc $bcc -Subject $subject -Body $body -bodyasHTML -Attachments $logfile -Encoding $mailEncoding
    }

### Script
foreach ($krbtgt IN $accounts)
    {
    [string]$kname = $krbtgt.Name
    [Datetime]$kpls = $krbtgt.PasswordLastSet

    if ($krbtgt.pwdLastSet -lt $currentDate)
        {
        Add-Content $logfile "[$(Get-Date -Format "dd/MM/yyyy_HH:mm:ss")] Il faut renouveler le password du compte $kname d'$domain qui date du $kpls (US date)"
        Write-Host "[$(Get-Date -Format "dd/MM/yyyy_HH:mm:ss")] Il faut renouveler le password du compte $kname d'$domain qui date du $kpls (US date)" -BackgroundColor DarkRed
        Mail "[$env][$domain] Compte krbtgt : Renouvellement du mot de passe" "Le mot de passe du compte krbtgt du domaine $domain.edf.fr a plus de 6 mois ($kpls US date), il faut le renouveller !"
        }
        else
            {
            Add-Content $logfile "[$(Get-Date -Format "dd/MM/yyyy_HH:mm:ss")] Le mot de passe du compte $kname a moins de 6 mois"
            Write-host "[$(Get-Date -Format "dd/MM/yyyy_HH:mm:ss")] Le mot de passe du compte $kname a moins de 6 mois"
            }
    }
Add-Content $logfile "[$(Get-Date -Format "dd/MM/yyyy_HH:mm:ss")] ### Fin du script Check_KRBTGT ###"
Write-Host "[$(Get-Date -Format "dd/MM/yyyy_HH:mm:ss")] ### Fin du script Check_KRBTGT ###"
