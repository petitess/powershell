# Variables
$systemMessageColor = "cyan"
$processMessageColor = "green"
$errorMessageColor = "red"
$warningMessageColor = "yellow"

Write-Host -ForegroundColor $systemMessageColor "Script started`n"
Write-Host "--- Script to delete app permissions from an Entra ID application in a tenant ---"

Write-Host -ForegroundColor $processMessageColor "`nChecking for Microsoft Graph PowerShell module"
if (Get-Module -ListAvailable -Name Microsoft.Graph.Authentication) {
    Write-Host -ForegroundColor $processMessageColor "Microsoft Graph PowerShell module found"
}
else {
    Write-Host -ForegroundColor $warningMessageColor -BackgroundColor $errorMessageColor "Microsoft Graph PowerShell Module not installed. Please install and re-run the script`n"
    Write-Host "You can install the Microsoft Graph PowerShell module by:`n"
    Write-Host "    1. Launching an elevated PowerShell console then,"
    Write-Host "    2. Running the command, 'Install-Module -Name Microsoft.Graph'.`n"
    Pause ## Pause to view error on screen
    exit 0 ## Terminate script
}

Connect-MgGraph -Scopes "User.ReadWrite.All", "Application.ReadWrite.All", "DelegatedPermissionGrant.ReadWrite.All"

$results = Get-MgServicePrincipal -All | Select-Object Id, AppId, DisplayName | Sort-Object DisplayName | Out-GridView -PassThru -Title "Select Application (Multiple selections permitted)"
foreach ($result in $results) {
    # Loop through all selected options
    Write-Host -ForegroundColor $processMessageColor "Commencing", $result.DisplayName
    # Get Service Principal using objectId
    $sp = Get-MgServicePrincipal -All | Where-Object { $_.Id -eq $result.Id }
    # Menu selection for User or Admin consent types
    $consentType = @()
    $consentType += [PSCustomObject]@{ Name = "Admin consent"; Type = "allprincipals" }
    $consentType += [PSCustomObject]@{ Name = "User consent"; Type = "principal" }
    $consentSelects = $consentType | Out-GridView -PassThru -Title "Select Consent type (Multiple selections permitted)"

    foreach ($consentSelect in $consentSelects) {
        # Loop through all selected options
        Write-Host -ForegroundColor $processMessageColor "Commencing for", $consentSelect.Name
        # Get all delegated permissions for the service principal
        $spOAuth2PermissionsGrants = Get-MgOauth2PermissionGrant -All | Where-Object { $_.clientId -eq $sp.Id }
        $info = $spOAuth2PermissionsGrants | Where-Object { $_.consentType -eq $consentSelect.Type }
        
        if ($info) {
            # If there are permissions set
            if ($consentSelect.Type -eq "principal") {
                # User consent
                $usernames = @()
                foreach ($item in $info) {
                    $usernames += Get-MgUser -UserId $item.PrincipalId
                }
                $selectUsers = $usernames | Select-Object Displayname, UserPrincipalName, Id | Sort-Object Displayname | Out-GridView -PassThru -Title "Select Consent type (Multiple selections permitted)"
                foreach ($selectUser in $selectUsers) {
                    # Loop through all selected options
                    $infoScopes = $info | Where-Object { $_.principalId -eq $selectUser.Id }
                    Write-Host -ForegroundColor $processMessageColor "`n"$consentSelect.Name, "permissions for user", $selectUser.Displayname
                    foreach ($infoScope in $infoScopes) {
                        Write-Host "`nResource ID =", $infoScope.ResourceId
                        $assignments = $infoScope.Scope -split " "
                        foreach ($assignment in $assignments) {
                            Write-Host "-", $assignment
                        }
                    }
                    Write-Host -ForegroundColor $processMessageColor "`nSelect items to remove`n"
                    $removes = $infoScopes | Select-Object Scope, ResourceId, Id | Out-GridView -PassThru -Title "Select permissions to delete (Multiple selections permitted)"
                    foreach ($remove in $removes) {
                        Remove-MgOauth2PermissionGrant -OAuth2PermissionGrantId $remove.Id
                        Write-Host -ForegroundColor $warningMessageColor "Removed consent for", $remove.Scope
                    }
                }
            } 
            elseif ($consentSelect.Type -eq "allprincipals") {
                # Admin consent
                $infoScopes = $info | Where-Object { $_.principalId -eq $null }
                Write-Host -ForegroundColor $processMessageColor $consentSelect.Name, "permissions"
                foreach ($infoScope in $infoScopes) {
                    Write-Host "`nResource ID =", $infoScope.ResourceId
                    $assignments = $infoScope.Scope -split " "
                    foreach ($assignment in $assignments) {
                        Write-Host "-", $assignment
                    }
                }
                Write-Host -ForegroundColor $processMessageColor "`nSelect items to remove`n"
                $removes = $infoScopes | Select-Object Scope, ResourceId, Id | Out-GridView -PassThru -Title "Select permissions to delete (Multiple selections permitted)"
                foreach ($remove in $removes) {
                    Remove-MgOauth2PermissionGrant -OAuth2PermissionGrantId $remove.Id
                    Write-Host -ForegroundColor $warningMessageColor "Removed consent for", $remove.Scope
                }
            }
        }
        else {
            Write-Host -ForegroundColor $warningMessageColor "`nNo", $consentSelect.Name, "permissions found for" , $results.DisplayName, "`n"
        }
    }
}

Write-Host -ForegroundColor $systemMessageColor "`nScript Finished"
