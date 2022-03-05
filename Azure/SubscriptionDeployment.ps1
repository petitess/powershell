Connect-AzAccount

Get-AzSubscription

Set-Location "C:\Users\Karol\Enviroment"

New-AzSubscriptionDeployment -TemplateFile main.bicep -Location "swedencentral" -Name KarolDeploy
