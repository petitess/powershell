#Remove the last character from a string
$Name = 'vmadcprod03_OsDisk_1_a491e9ab84ec436fa00d4c500f11d24f-20230915'
$Name.Substring(0,$ComputerName.Length-8)
"$((($Name).Replace('snap-', '')).Substring(0,($Name).Length-14)).vhd"



