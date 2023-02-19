$printers = Get-Printer | where {$_.Name -match "SafeQx"}

foreach ($printer in $printers) {
Remove-Printer -Name $printer.Name
}

Set-Itemproperty -path 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Windows' -Name 'LegacyDefaultPrinterMode' -value '0'
