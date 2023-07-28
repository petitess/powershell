Get-MgUser -All

Get-MgUser -Filter "DisplayName eq 'Karol'"

Get-MgUser -Filter "startsWith(DisplayName, 'A')"

Get-MgUser -Filter 'accountEnabled eq true' -All

Get-MgUser -Filter 'accountEnabled eq true' -Search 'DisplayName:van' -ConsistencyLevel eventual

Get-MgUser -UserId adelev@lazydev.onmicrosoft.com -ExpandProperty manager | Select @{Name = 'Manager'; Expression = {$_.Manager.AdditionalProperties.displayName}}

$props = @(
    # Basic metadata
    'Id','DisplayName','Mail','UserPrincipalName','Department','JobTitle'
    # Account Status
    'AccountEnabled',
    # Password last set
    'LastPasswordChangeDateTime'
    # Last logon
    #'SignInActivity'
    # Assigned Licenses
    #'AssignedLicenses'
)
Get-MgUser -All -Property $props | Select-Object $props
