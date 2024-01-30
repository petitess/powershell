$htmlString = ''
$firstString = '<title>'
$secondString = '</title>'
$pattern = "$firstString(.*?)$secondString"
$result = [regex]::Match($htmlString,$pattern).Groups[1].Value
$result

##extract text between []
$existingMsg = "[532454] [CUSTOMER] ALERT TEST"
[regex]::Matches($M , '(?<=\[)[^]]+(?=\])').Value[0]
