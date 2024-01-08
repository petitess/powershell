$SubName = "sub-default-01"
$OldMg = "xxxxx-aa48-43c6-a39a-xxxx"
$NewMg = "mg-default-01"
$Sub = Get-AzManagementGroupSubscription -GroupName $OldMg | Where-Object {$_.DisplayName -eq $SubName}
$SubId = $($Sub.Id).Replace("/providers/Microsoft.Management/managementGroups/$OldMg/subscriptions/", "")
New-AzManagementGroupSubscription -GroupName $NewMg -SubscriptionId $SubId
