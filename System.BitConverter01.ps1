$User = 'x1111'
$Pass = "Pass.23"
$Domain = "xxx.se"
$Permissions = "CONTACT:CALLS:USER:CDR_READER:COMMUNICATION_LOG:DISTRIBUTION_GROUP:PERSONAL_CONTACTS:QUEUE_STATS"

$String1 = "$($User):$($Domain):$($Pass)"
$String1MD5 = ([System.BitConverter]::ToString((New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider).ComputeHash((New-Object -TypeName System.Text.UTF8Encoding).GetBytes($String1)))).Replace("-","")
$String1MD5

$String2 = "D$([Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($Domain)))"
$String2Encode64 = $String2.Replace("=", "")
$String2Encode64 #Result = DYjNpdC5zZQ

$String3 = $User + ":" + $Permissions + ":" + $String1MD5.ToLower()
$String3MD5 = ([System.BitConverter]::ToString((New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider).ComputeHash((New-Object -TypeName System.Text.UTF8Encoding).GetBytes($String3)))).Replace("-","")
$String3MD5

$String4 = "P:" + $String3MD5.ToLower() + ":" + $user + ":" + $Permissions
$String4Encode = "$([Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($String4)))"
$String4Encode64 = $String4Encode.Replace("=", "")

$PassToken = $String2Encode64 + "." + $String4Encode64

#With this token you can call Token API to renew API keys
#https://www.dstny.se/app/uploads/User-API-v-5.5.22336..html#tag/Tickets
