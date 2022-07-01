# 
#
# Variables
$mailFrom = <mail expediteur>
$mailTo = <mail destinataire>
$mailSubject = <sujet du mail>
$mailSmtpserver = <ip ou dns du smtpserver>
$mailBody = <corps du mail>
$mailAttachments = <chemin du fichier>

# Scripts




Send-MailMessage -From $mailFrom -To $mailTo - Subject $mailSubject - SmtpServer $mailSmtpserver -Body $mailBody -Attachments $mailAttachments
