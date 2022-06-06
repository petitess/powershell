(Get-AzRoleDefinition "Virtual Machine Contributor").Actions

(Get-AzRoleDefinition "Contributor").NotActions

Get-AzSubscriptionDeployment | where {$_.DeploymentName -match "Deploy"} | select DeploymentName