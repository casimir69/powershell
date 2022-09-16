<#
.DESCRIPTION
Check la présence de l'option "Never-Expire" sur tout les comptes du domaine.

.AUTEUR
casimir69
#>

Import-Module ActiveDirectory

[string]$version = "v20220916"
[int]$nbrAccount = "0"
[int]$nbrAccountNE = "0"
[string]$env = MQT    #PROD or MQT
[string]$domain = $env:USERDOMAIN
[string]$logfile = "$PSScriptRoot\Checks_Account-NeverExpire_"+ $domain +".log"
$users = Get-ADUser -Filter * -Properties Name, PasswordNeverExpires

Add-Content $logfile "[$(Get-Date -Format "dd/MM/yyyy_HH:mm:ss")] ### Début du script Check_Accounts-NeverExpire - $version ###"
Write-Host "[$(Get-Date -Format "dd/MM/yyyy_HH:mm:ss")] ### Début du script Check_Accounts-NeverExpire - $version ###"

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
    [string]$from = "Check_$domain@domain.fr"
    [string]$to =  "mailTo@domain.fr"
    [string]$bcc = "mailBcc@domain.fr"

    Add-Content $logfile "[$(Get-Date -Format "dd/MM/yyyy_HH:mm:ss")] Sendind Report Email from $from to $to"
    Write-Host "[$(Get-Date -Format "dd/MM/yyyy_HH:mm:ss")] Sendind Report Email from $from to $to"

    Send-MailMessage -SmtpServer $smtpServer -Port $port -From $from -To $to -Bcc $bcc -Subject $subject -Body $body -bodyasHTML -Attachments $logfile -Encoding $mailEncoding
    }
####################

foreach ($user IN $users)
    {
    [string]$name = $user.SamAccountName
    [bool]$state = $user.PasswordNeverExpires
    $nbrAccount++
    if ($state -like "$true")
        {
        $nbrAccountNE++
        Add-Content $logfile "[$(Get-Date -Format "dd/MM/yyyy_HH:mm:ss")] Le compte $name sur $domain a son mot de passe configuré en Never-Expire, merci de supprimer cette option."
        Write-Host "[$(Get-Date -Format "dd/MM/yyyy_HH:mm:ss")] Le compte $name sur $domain a son mot de passe configuré en Never-Expire, merci de supprimer cette option." -BackgroundColor DarkRed
        }
        elseif ($state -like "$false")
            {
            Add-Content $logfile "[$(Get-Date -Format "dd/MM/yyyy_HH:mm:ss")] Le compte $name sur $domain est conforme aux exigences."
            Write-host "[$(Get-Date -Format "dd/MM/yyyy_HH:mm:ss")] Le compte $name sur $domain est conforme aux exigences."
            }
    }    
    if ($nbrAccountNE -gt "0")
        {
        Mail "[$env][$domain] Compte(s) en Never-Expire" "Un ou plusieurs compte(s) on(t) l'option Never-Expire d'activée(s) ce qui n'est pas recommandé, merci d'y remédier. Voir la pièce jointe pour plus de détails"
        }
        Add-Content $logfile "[$(Get-Date -Format "dd/MM/yyyy_HH:mm:ss")] ### Fin du script Check_Accounts-NeverExpire - $nbrAccount comptes locaux ###"
        Write-Host "[$(Get-Date -Format "dd/MM/yyyy_HH:mm:ss")] ### Fin du script Check_Accounts-NeverExpire - $nbrAccount comptes locaux ###"