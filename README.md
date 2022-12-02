------------------------------------------------------------------------------------
## Espace dédié aux scripts Powershell

Quelques scripts powershell permettant de garder un oeil sur des éléments importants d'un Active Directory

### Check_KRBTGT.ps1

Vérifie de quand date le dernier changement du mot de passe et suggére son renouvellement le cas échéant, envoie de la log par mail si activé.

### Check_Accounts-NeverExpire.ps1

Verifie si les comptes utilisaterus d'OU determinée ont l'option Never-Expire d'activée, logging et envoie de la log par mail si activé

### Check_PwdExpirationToCSV.ps1

Vérifie si le mot de passe arrive bientot a expiration (ex: 21 jours avant l'expiration sur une expiration de 180 jours), envoie de la log par mail si activé.

### GPO_Backup.ps1

Sauvegarde l'ensemble des GPO et créé un fichier flag portant la date de la sauvegarde
