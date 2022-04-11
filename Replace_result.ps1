$result = Get-AzAutomationSoftwareUpdateMachineRun -ResourceGroupName B3CARE-NL-NET -AutomationAccountName B3CARE-NL-AUTOMATION  | select TargetComputer

$hash = @{}
 $hash.'{' = ''
 $hash."'" = ""
 $hash.'}' = ''
 #$hash.'[' = ''
 $hash.']' = ''
 $hash.'"' = ''
 $hash.'TargetComputer=/subscriptions/xxxxfdb8-ba53-409c-xxxx-9118f13f6470/resourceGroups/' = ''
 $hash.'TargetComputer=' = ''
 $hash.'@' = ''
 $hash.'xxxx-nl-ad/providers/Microsoft.Compute/virtualMachines/' = ''
 $hash.'xxxx-nl-mgt/providers/Microsoft.Compute/virtualMachines/' = ''


 Foreach ($key in $hash.Keys) {
    $result = $result -replace $key, $hash.$key
 }
 $result
