$Path = "C:\Windows\0Users"
$TestPath = Test-Path $Path
!$TestPath ? (New-Item -Path $Path -ItemType Directory -Force) : ''
$RegPath = "HKLM:\SOFTWARE\FSLogix\Profiles"

$Values = @(
    [pscustomobject]@{name = 'Enabled'; type = "DWord"; value = 1 }
    [pscustomobject]@{name = 'DeleteLocalProfileWhenVHDShouldApply'; type = "DWord"; value = 1 }
    [pscustomobject]@{name = 'FlipFlopProfileDirectoryName'; type = "DWord"; value = 1 }
    [pscustomobject]@{name = 'LockedRetryCount'; type = "DWord"; value = 15 }
    [pscustomobject]@{name = 'LockedRetryInterval'; type = "DWord"; value = 1 }
    [pscustomobject]@{name = 'ProfileType'; type = "DWord"; value = 0 }
    [pscustomobject]@{name = 'ReAttachIntervalSeconds'; type = "DWord"; value = 15 }
    [pscustomobject]@{name = 'ReAttachRetryCount'; type = "DWord"; value = 15 }
    [pscustomobject]@{name = 'SizeInMBs'; type = "DWord"; value = 30000 }
    [pscustomobject]@{name = 'VHDLocations'; type = "String"; value = $Path }
    [pscustomobject]@{name = 'VolumeType'; type = "String"; value = "VHDX" }
)

$Values | ForEach-Object {
    Set-ItemProperty -Path $regPath -Name $_.name -Value $_.value -Type $_.type | Out-Null
}
