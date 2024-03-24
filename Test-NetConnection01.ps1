$IP = "40.68.152.181"
$Ports = @(
    445
    3389
    5986
)

$Ports | ForEach-Object {
    $Test = Test-NetConnection -ComputerName $IP -Port $_
    Write-Output "$($_;  $Test.TcpTestSucceeded)"
}
