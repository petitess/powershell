Connect-MgGraph -TenantId "xxx" -Scopes 'User.Read.All'

Connect-MgGraph -Scopes "User.Read.All","MailboxSettings.Read"

Get-MgContext

Get-MgUser -All
