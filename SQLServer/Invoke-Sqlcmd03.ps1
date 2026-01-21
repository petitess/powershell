$Databases = (Invoke-Sqlcmd -ServerInstance "VM01" -Database "CodetrackV2" -Query "
    SELECT TABLE_NAME
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_TYPE = 'BASE TABLE'").TABLE_NAME

$($Databases | Sort-Object $_) | ForEach-Object {
    $DbName = $_
    $I = Invoke-Sqlcmd `
        -Query "SELECT * from [CodetrackV2].dbo.$DbName" `
        -ServerInstance "VM01" `
        -Database "CodetrackV2" `
        -ConnectionTimeout 10

    # Export to CSV with timestamp
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $outputPath = "D:\temp\$($DbName)_$timestamp.csv"

    $I | Export-Csv -Path $outputPath -NoTypeInformation -Encoding UTF8

    Write-Host "Export completed: $outputPath"
}
