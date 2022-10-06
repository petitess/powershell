Get-Date

Get-Date -DisplayHint Date

Get-Date -Format "dddd MM/dd/yyyy HH:mm K"

Get-Date -Format "MM/dd/yyyy"

Get-Date -UFormat "%m/%d/%Y %R"

$Temp = (Get-date).AddDays(1)
Get-Date $Temp -UFormat "%m/%d/%Y %R"

$time = "20:30"
$Temp = (Get-date).AddDays(1)
$x = Get-Date $Temp -UFormat "%m/%d/%Y $time"

$now = Get-Date -UFormat "%R"
if ($now -ge "15:55"){
Write-Output "klockan har passerat 15:55"
}else {
Write-Output "klockan har inte passerat 15:55"
}

$now = Get-Date -UFormat "%R"
if ($now -ge "15:55"){
$time = "20:30"
$Temp = (Get-date).AddDays(1)
Get-Date $Temp -UFormat "%m/%d/%Y $time"
}else {
$time = "20:30"
Get-Date -UFormat "%m/%d/%Y $time"
}