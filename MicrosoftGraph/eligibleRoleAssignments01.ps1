$Scopes = @(
    "RoleManagement.ReadWrite.Directory"
)
Select-MgProfile -Name 'beta'
Connect-MgGraph -Scopes $Scopes

$EligibleAADUserData = @()
$EligibleAADGroupData = @()
$EligileAssignments = Get-MgRoleManagementDirectoryRoleEligibilityScheduleInstance -ExpandProperty "*" -All
foreach($Role in $EligileAssignments){

    If($Role.Principal.AdditionalProperties.'@odata.type' -eq "#microsoft.graph.user"){
        $UserProperties = [pscustomobject]@{
            displayName = $Role.Principal.AdditionalProperties.displayName
            accountEnabled = $Role.Principal.AdditionalProperties.accountEnabled
            StartDateTime = $Role.StartDateTime
            EndDateTime = $Role.EndDateTime
            MemberType = $Role.MemberType
            RoleName = $Role.RoleDefinition.DisplayName
            RoleID = $Role.RoleDefinition.Id
        }
        $EligibleAADUserData += $UserProperties
    }
    Else{
        $GroupProperties = [pscustomobject]@{
            displayName = $Role.Principal.AdditionalProperties.displayName
            isAssignableToRole = $Role.Principal.AdditionalProperties.isAssignableToRole
            StartDateTime = $Role.StartDateTime
            EndDateTime = If($null -eq $Role.EndDateTime){"Permanent"}
            MemberType = $Role.MemberType
            RoleName = $Role.RoleDefinition.DisplayName
            RoleID = $Role.RoleDefinition.Id
        }
        $EligibleAADGroupData += $GroupProperties
    }
}
#Print out the details
$EligibleAADUserData
$EligibleAADGroupData
