Import-Module az.resources
Import-Module AzTable
Import-Module az.storage

# Step 1, Set variables
# Enter Table Storage location data 
$storageAccountName = 'adpasswordexpiration'
$tableName = 'userpasswordexpiration'
$sasToken = '?sv=2019-12-12&ss=t&srt=co&sp=rwdlacu&se=2030-11-16T21:59:17Z&st=2020-11-16T13:59:17Z&spr=https&sig=Q0%2BEwKaQfUA3Vz1lfnPiuWuZmyii8BaJONp4cwMBxEA%3D'
$dateTime = get-date
$partitionKey = 'AzDC03passwordexpiration'
$users = @()

# Step 2, Connect to Azure Table Storage
$storageCtx = New-AzStorageContext -StorageAccountName $storageAccountName -SasToken $sasToken
$table = (Get-AzStorageTable -Name $tableName -Context $storageCtx).CloudTable


#Get-AzTableRow -Table $Table -ColumnName "WriteTime" -Value $dateTime.ToString("yyyyMMdd") -Operator NotEqual | Remove-AzTableRow -Table $Table
Get-AzTableRow -Table $Table | Remove-AzTableRow -Table $Table


Add-AzTableRow -table $table -partitionKey $partitionKey -rowKey ([guid]::NewGuid().tostring()) -property @{
 'WriteTime' = $dateTime.ToString("yyyyMMdd")
 'UserPrincipalName' = 'Success'
 'Name' = 'Success'
 'Mail' = 'Success'
 'ExpiryDate' = 'Success'
 } | Out-Null

# Step 3, get the data 
$users = Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} -Properties UserPrincipalName, msDS-UserPasswordExpiryTimeComputed, mail, name | `
    ?{[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed") -lt (Get-Date).AddDays(7) -and [datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed") -ge (Get-Date) -and $null -ne $_.mail} | `
    Select-Object -Property "Name", "UserPrincipalName","mail",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}

foreach ($user in $users) {
 Add-AzTableRow -table $table -partitionKey $partitionKey -rowKey ([guid]::NewGuid().tostring()) -property @{
 'WriteTime' = $dateTime.ToString("yyyyMMdd")
 'UserPrincipalName' = $user.UserPrincipalName
 'Name' = $user.Name
 'Mail' = $user.mail
 'ExpiryDate' = $user.ExpiryDate.ToString("yyyy-MM-dd")
 } | Out-Null
}