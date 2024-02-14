#Import SharePoint Online and Azure Online modules
Import-Module Microsoft.Online.SharePoint.Powershell
Import-Module MSOnline

#Config Parameters
$AdminURL ="https://xxxxxx.sharepoint.com"
$ReportOutput="C:\temp\OrphanUsersxxx-sitesincluded.csv"

#Get Credentials to connect


$password = ConvertTo-SecureString 'xxxxxxxx' -AsPlainText -Force
$user = "xxxxxx@xxx365.onmicrosoft.com"
$credential = New-Object System.Management.Automation.PSCredential ($user, $password)
$Cred = Get-Credential -Credential $credential
 
#Connect to SharePoint and Azure AD
Connect-MsolService -Credential $Cred
Connect-SPOService -Url $AdminURL -Credential  $Cred

Function Generate-OrphanedUsersReport ()
{
param
    (
        [Parameter(Mandatory=$true)] [string] $AdminURL,
        [Parameter(Mandatory=$true)] [string] $SiteURL,
        [Parameter(Mandatory=$true)] [string] $ReportOutput       
    )
Try {
    
 
    #Function to check if a user account exists
    Function Check-UserExists()
    {
        Param( [Parameter(Mandatory=$true)] [string]$UserID )
     
        $User=Get-Msoluser -UserPrincipalName $UserID -Erroraction SilentlyContinue
        if ($User -ne $null)
        {
            Return $True
        }
        else
        {
            Return $false
        }
    }
    $OrphanedUsers = @()
 
    #Get all users of a given SharePoint Online site collection
    $AllUsers = Get-SPOUser $SiteURL -Limit ALL
 
    Foreach($User in $AllUsers)
    {
        #Exclude Built-in User Accounts and Security Groups 
        if(($User.DisplayName.ToLower() -ne "nt authority\authenticated users") -and ($User.LoginName.ToLower() -ne "sharepoint\system") -and
        ($User.DisplayName.ToLower() -ne "sharepoint app") -and ($user.IsGroup -eq $false ) -and(-not $user.DisplayName.ToLower().Contains("_spocache")) -and
        (-not $user.DisplayName.ToLower().Contains("_spocrawl")) -and ($User.DisplayName.ToLower() -ne "sharepoint service administrator") -and
        ($User.DisplayName.ToLower() -ne "guest contributor") -and ($User.DisplayName.ToLower() -ne "everyone except external users")-and ($User.DisplayName.ToLower() -ne "company administrator"))
        {
            Write-host "Checking user $($user.DisplayName)" -f Yellow
            #Check if user exists
            if((Check-UserExists $User.LoginName) -eq $False)
            {
                Write-Host "User Doesn't Exists: $($user.DisplayName) - $($User.LoginName) in $($SiteURL)" -f Red
 
                #Send the Result to CSV 
                $Result = new-object PSObject
                $Result| add-member -membertype NoteProperty -name "LoginName" -Value $User.LoginName
                $Result | add-member -membertype NoteProperty -name "DisplayName" -Value $User.DisplayName
                $Result | add-member -membertype NoteProperty -name "Site" -Value "$($SiteURL)"
                $OrphanedUsers += $Result
            }
        }
    }
    #Export results to CSV
    $OrphanedUsers | Export-csv $ReportOutput -Append -notypeinformation
 
        Write-host "Orphan Users Report Generated to $ReportOutput" -f Green
   }
 
    Catch {
    write-host -f Red "Error Deleting Unique Permissions!" $_.Exception.Message $SiteURL
    }
}
 

Get-SPOSite -Limit all | ForEach-Object{ 
#Call the function to find and generate orphaned users report
Generate-OrphanedUsersReport -AdminURL $AdminURL -SiteURL $_.url -ReportOutput $ReportOutput
}
