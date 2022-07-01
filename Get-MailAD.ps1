 Function get-emailAD{

    param([System.String] $searchString)

    [System.DirectoryServices.DirectorySearcher] $searcher = New-Object System.DirectoryServices.DirectorySearcher

    $searcher.Filter = "(&(objectCategory=User)(Name=$searchString*))"

    $path = $searcher.FindOne()

    if($path){

    $user = $path.GetDirectoryEntry()
    $EMAIL =$user.mail
  #  write-host "$searchString : $EMAIL"
    return $EMAIL
    }

}  
