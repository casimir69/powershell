<#
.DESCRIPTION
        Notifier la futur expiration du mot de passe des comptes de services
        Vérifié dans Ping Castle

.AUTHOR
        casimir69
#>

##### module #####
If ( (Get-Module -Name ActiveDirectory -ErrorAction SilentlyContinue) -eq $null )
{
    Try {
        Import-Module ActiveDirectory
        }
        Catch {
              Write-Error "Unable to load the module" -ErrorAction Continue
              Write-Error $Error[1] -ErrorAction Continue
              Exit 1
    }
}

##### variable #####
[string]$scriptVersion = "v20220919"
[datetime]$currentDate = (Get-Date).Date.AddDays(-159) #159j correspond à 21j avant l'expiration
[bool]$mailreport = 0              #1 or 0 or True or False
[string]$domain = $env:USERDOMAIN
[string]$env = MQT                 #PROD or MQT
[int]$nbrAccountNE = "0"
[string]$logfile = "$PSScriptRoot\Checks_PwdExpirationToCSV_"+ $domain +".log"
$accounts = Get-ADUser -Filter * -Properties Name, PasswordExpired, PasswordLastSet | where {$_.sAMAccountName -Like "CSV_*"} | where {$_.Enabled -eq "True"} 

Add-Content $logfile "[$(Get-Date -Format "dd/MM/yyyy_HH:mm:ss")] ### Début du script Check_PwdExpirationToCSV.ps1 - $scriptVersion ###"
Write-Host "[$(Get-Date -Format "dd/MM/yyyy_HH:mm:ss")] ### Début du script Check_PwdExpirationToCSV.ps1 - $scriptVersion ###"

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
foreach ($account IN $accounts)
    {
    [string]$SamAccountName = $account.SamAccountName
    [datetime]$accountPLS = $account.PasswordLastSet
    
    if ($accountPLS -lt $currentDate)
        {
        $nbrAccountNE++
        Add-Content $logfile "[$(Get-Date -Format "dd/MM/yyyy_HH:mm:ss")] Il faut renouveler le password du compte $SamAccountName d'$domain qui date du $accountPLS (US date)"
        Write-Host "[$(Get-Date -Format "dd/MM/yyyy_HH:mm:ss")] Il faut renouveler le password du compte $SamAccountName d'$domain qui date du $accountPLS (US date)" -BackgroundColor DarkRed
        }
        else
            {
            Add-Content $logfile "[$(Get-Date -Format "dd/MM/yyyy_HH:mm:ss")] Le mot de passe du compte $SamAccountName a moins de 6 mois"
            Write-host "[$(Get-Date -Format "dd/MM/yyyy_HH:mm:ss")] Le mot de passe du compte $SamAccountName a moins de 6 mois"
            }
    }
    if ($nbrAccountNE -gt "0")
        {
        if ($mailreport -eq true)
            {
            Mail "[$env][$domain] Expiration du mdp des comptes CSV (j-21)" "Le mot de passe d'un ou plusieurs comptes de service sont à renouveler, merci d'y remédier. Voir la pièce jointe pour plus de détails"
            }
        }
        Add-Content $logfile "[$(Get-Date -Format "dd/MM/yyyy_HH:mm:ss")] ### Fin du script Check_PwdExpirationToCSV.ps1 ###"
        Write-Host "[$(Get-Date -Format "dd/MM/yyyy_HH:mm:ss")] ### Fin du script Check_PwdExpirationToCSV.ps1 ###"
