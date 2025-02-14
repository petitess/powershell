#Created by Johan Öberg, ChatGPT and some dude on Github
#I HATE GUI BASED PIM ACTIVATION

# Connect via deviceauthentication and get the TenantID and User ObjectID
Connect-MgGraph -NoWelcome
Import-Module Microsoft.Graph.Authentication
Import-Module Microsoft.Graph.Identity.DirectoryManagement
$context = Get-MgContext
$currentUser = (Get-MgUser -UserId $context.Account).Id

# Get all available roles
$myRoles = Get-MgRoleManagementDirectoryRoleEligibilitySchedule -ExpandProperty RoleDefinition -All -Filter "principalId eq '$currentUser'"

# Display available roles and let the user select one
$roleNames = $myRoles | Select-Object -ExpandProperty RoleDefinition | Select-Object -ExpandProperty DisplayName

Write-Host "Please select a role by entering the corresponding number:"
for ($i = 0; $i -lt $roleNames.Count; $i++) {
    Write-Host "$($i+1): $($roleNames[$i])"
}

# Read the user's choice
$selectedRoleIndex = Read-Host "Enter the number of the role to activate"

# Check if the selected index is valid
if ($selectedRoleIndex -gt 0 -and $selectedRoleIndex -le $roleNames.Count) {
    $selectedRoleName = $roleNames[$selectedRoleIndex - 1]

    # Get the selected role object based on the DisplayName
    $myRole = $myRoles | Where-Object { $_.RoleDefinition.DisplayName -eq $selectedRoleName }

    # Setup parameters for activation
    $params = @{
        Action = "selfActivate"
        PrincipalId = $myRole.PrincipalId
        RoleDefinitionId = $myRole.RoleDefinitionId
        DirectoryScopeId = $myRole.DirectoryScopeId
        Justification = "Enable Admin Role"
        ScheduleInfo = @{
            StartDateTime = Get-Date
            Expiration = @{
                Type = "AfterDuration"
                Duration = "PT8H"
            }
        }
    }

    # Activate the role
    New-MgRoleManagementDirectoryRoleAssignmentScheduleRequest -BodyParameter $params
    Write-Host "Role activation request has been submitted."
} else {
    Write-Host "Invalid selection or no role selected. Script will exit."
}
