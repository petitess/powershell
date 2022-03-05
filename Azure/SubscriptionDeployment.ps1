Connect-AzAccount

Get-AzSubscription

Set-Location "C:\Users\Karol\OneDrive - B3 Consulting Group AB\Enviroment"

New-AzSubscriptionDeployment -TemplateFile main.bicep -Location "swedencentral" -Name KarolDeploy