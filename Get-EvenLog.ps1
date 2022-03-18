#
$DatGete = [DateTime]::Now.AddDays(-100) 
Get-EventLog -LogName Application -After $Date | Where -FilterScript {$_.EventID -eq 11707}  

#
$Date = [DateTime]::Now.AddDays(-1) 
Get-EventLog -LogName "Security" -After $Date | Where -FilterScript {$_.EventID -eq 4624}      

#
Get-WinEvent -FilterHashtable @{LogName = 'Security'; ID = 4624} -MaxEvents 10
