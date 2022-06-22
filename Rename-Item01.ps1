

$numarray = 1
#$numarray | ForEach-Object {"{0:D2}" -f $numarray++}
Get-ChildItem "c:\dp\$_" | Sort-Object {Get-Random} | ForEach {Rename-Item -Path "c:\dp\$_" -NewName (("{0:D3}" -f $numarray+++ "." +$_.Name))}
