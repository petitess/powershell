#Clean Disk

$disknr = 2
$diskletter = "K"

Clear-Disk -Number $disknr -RemoveData -Confirm:$false
Initialize-Disk -Number $disknr -PartitionStyle GPT
New-Partition -DiskNumber $disknr -DriveLetter $diskletter -UseMaximumSize
Format-Volume -DriveLetter $diskletter -FileSystem NTFS -Confirm:$false
