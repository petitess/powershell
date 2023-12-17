$htmlString = ''
$firstString = '<title>'
$secondString = '</title>'
$pattern = "$firstString(.*?)$secondString"
$result = [regex]::Match($htmlString,$pattern).Groups[1].Value
$result
