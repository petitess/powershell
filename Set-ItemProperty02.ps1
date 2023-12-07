$RegPathIcons = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
$Values = @(
[pscustomobject]@{name = '{20D04FE0-3AEA-1069-A2D8-08002B30309D}'; type = "DWord"; value = 0 }
[pscustomobject]@{name = '{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}'; type = "DWord"; value = 0 }
[pscustomobject]@{name = '{59031a47-3f72-44a7-89c5-5595fe6b30ee}'; type = "DWord"; value = 0 }
[pscustomobject]@{name = '{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}'; type = "DWord"; value = 0 }
)

$Values | ForEach-Object {
    Set-ItemProperty -Path $RegPathIcons -Name $_.name -Value $_.value -Type $_.type | Out-Null
}
