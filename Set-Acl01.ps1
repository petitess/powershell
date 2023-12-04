$Acl = Get-Acl "Z:"

$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule("everyone", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")

$Acl.SetAccessRule($Ar)
Set-Acl "Z:" $Acl
#######
$Acl = Get-Acl "Z:"

$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule("AzureAD\mattias.xxx.ext.ext@xxx.se", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")

$Acl.SetAccessRule($Ar)
Set-Acl "Z:" $Acl
