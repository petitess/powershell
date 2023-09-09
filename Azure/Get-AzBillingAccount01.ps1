$billingAccounts = (Get-AzBillingAccount).Name
$billingProfile = (Get-AzBillingProfile -BillingAccountName $billingAccounts).Name
$invoiceSections = (Get-AzInvoiceSection -BillingAccountName (Get-AzBillingAccount).Name -BillingProfileName $billingProfile).Name
$billingScope = "/providers/Microsoft.Billing/billingAccounts/$billingAccounts/billingProfiles/$billingProfile/invoiceSections/$invoiceSections"
$billingScope
