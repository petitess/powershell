#requires -RunAsAdministrator
#You can run this in azure using "Run command"

# there REALLY otta be a way to get this list programmatically
$LogonTypeTable = [ordered]@{
    '0' = 'System'
    '2' = 'Interactive'
    '3' = 'Network'
    '4' = 'Batch'
    '5' = 'Service'
    '6' = 'Proxy'
    '7' = 'Unlock'
    '8' = 'NetworkCleartext'
    '9' = 'NewCredentials'
    '10' = 'RemoteInteractive'
    '11' = 'CachedInteractive'
    '12' = 'CachedRemoteInteractive'
    '13' = 'CachedUnlock'
    }
$EventLevelTable = [ordered]@{
    LogAlways = 0
    Critical = 1
    Error = 2
    Warning = 3
    Informational = 4
    Verbose = 5
    }


$WantedLogonTypes = @(2, 3, 10, 11)
$AgeInDays = 15
$StartDate = (Get-Date).AddDays(-$AgeInDays)

$ComputerName = $env:COMPUTERNAME
$GWE_FilterHashTable = @{
    Logname = 'Security'
    ID = 4624
    StartTime = $StartDate
    #Level  = 2
    }
$GWE_Params = @{
    FilterHashtable = $GWE_FilterHashTable
    ComputerName = $ComputerName
    MaxEvents = 100
    }
$RawLogonEventList = Get-WinEvent @GWE_Params

$LogonEventList = foreach ($RLEL_Item in $RawLogonEventList)
    {
    $LogonTypeID = $RLEL_Item.Properties[8].Value
    if ($LogonTypeID -in $WantedLogonTypes)
        {
        [PSCustomObject]@{
            LogName = $RLEL_Item.LogName
            TimeCreated = $RLEL_Item.TimeCreated
            UserName = $RLEL_Item.Properties[5].Value
            LogonTypeID = $LogonTypeID
            LogonTypeName = $LogonTypeTable[$LogonTypeID.ToString()]
            }
        }
    }

$NewestLogonPerUser = $LogonEventList |
    Sort-Object -Property UserName |
    Group-Object -Property UserName |
    ForEach-Object {
        if ($_.Count -gt 1)
            {
            $_.Group[0]
            }
            else
            {
            $_.Group
            }
        }

$NewestLogonPerUser | select username
