$subscriptions = Get-AzSubscription

ForEach ($Subscription in $Subscriptions) {
    Set-AzContext -SubscriptionId $Subscription.Id

    $RCvaults = get-azrecoveryservicesvault
    
    ForEach ($RCvault in $RCvaults) 
    {
        Set-AzRecoveryServicesVaultContext -Vault $RCvault
        Get-AzRecoveryServicesBackupJob
    }
}
