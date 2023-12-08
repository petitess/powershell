$Acl = Get-Acl "Z:"

$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule("everyone", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")

$Acl.SetAccessRule($Ar)
Set-Acl "Z:" $Acl
#######
$Acl = Get-Acl "Z:"

$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule("AzureAD\mattias.xxx.ext.ext@xxx.se", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")

$Acl.SetAccessRule($Ar)
Set-Acl "Z:" $Acl
#English
$Path = "D:\XXX"
$Acl = Get-Acl $Path
$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule("everyone", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
$Acl.SetAccessRule($Ar)
Set-Acl $Path $Acl
#Swedish
$Path = "D:\XXX"
$Acl = Get-Acl "D:\XXX"
$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule("alla", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
$Acl.SetAccessRule($Ar)
Set-Acl $Path $Acl
