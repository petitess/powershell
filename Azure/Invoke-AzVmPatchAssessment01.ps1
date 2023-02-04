Invoke-AzVmPatchAssessment -ResourceGroupName rg-vmmgmtprod01 -VMName vmmgmtprod01

Invoke-AzVMInstallPatch  `
-ResourceGroupName rg-vmmgmtprod01 `
-VMName vmmgmtprod01 `
-Windows `
-RebootSetting IfRequired `
-MaximumDuration PT4H `
-ClassificationToIncludeForWindows Definition, Critical, Security


Invoke-AzVMInstallPatch `
-ResourceGroupName rg-vmmonprod01 `
-VMName vmmonprod01 `
-Linux `
-RebootSetting IfRequired `
-MaximumDuration PT4H `
-ClassificationToIncludeForLinux Critical, Security
