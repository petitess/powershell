
$subscripionList =  Get-AzSubscription 

 ForEach ($subscriptionId in $subscripionList) {
    Set-AzContext -Subscription $subscriptionId

    $resources = Get-AzResource | Where-Object {$_.Tags.Values -eq "dev"}

        foreach ($resource in $resources) {

        $Res = $resource | select name, ResourceGroupName, SubscriptionId
        Write-Host $resource.Name $resource.ResourceGroupName $resource.SubscriptionId
        $Res | Export-Csv C:\Users\$env:username\Desktop\Res$(Get-Date -Format 'yyyy-MM-dd').csv -Append -Encoding UTF8
    }
}

#Compare files

$File1 = Import-Csv -Path "C:\Users\$env:username\Desktop\Res$((get-date).AddDays(-1).ToString("yyy-MM-dd")).csv"
$File2 = Import-Csv -Path "C:\Users\$env:username\Desktop\Res$(Get-Date -Format 'yyyy-MM-dd').csv"
Write-Host "NYA RESURSER:"
Compare-Object $File1 $File2 | select inputobject


