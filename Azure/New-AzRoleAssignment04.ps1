$Roles = @( 
    'Reader' 
    'Contributor' 
    'Owner' ) 
$SubName = ""    
$Scope = (Get-AzSubscription -SubscriptionName $SubName).Id 

foreach ($Role in $Roles) { 
    $GroupName = "grp-rbac-$SubName-$Role" 
    if (!(Get-AzADGroup -DisplayName $GroupName)) { 
        $Group = New-AzADGroup -DisplayName $GroupName -MailNickname $GroupName 
        Write-Output "Group created: $GroupName" 
        while (!(Get-AzRoleAssignment -Scope "/subscriptions/$Scope" -ObjectId $Group.Id -RoleDefinitionName $Role)) {
            try {
                New-AzRoleAssignment -Scope "/subscriptions/$Scope" -ObjectId $Group.Id -RoleDefinitionName $Role -ObjectType Group 2> $null
            }
            catch {}
        }
    }
}
