$testChars = '[{"user":"UserName1","date":"Fri, 15 Dec 2017 12:31:03 GMT","
    action":"Submitted","comment":"I have submitted for Approval"|
    "user":"UserName2","date":"Fri, 15 Dec 2017 13:14:21 GMT","action":"APPROVED","comme
    nt":"This has been approved......"|"user":"UserName1","date":"Fri, 15 Dec 2017 12:31:03 GMT","
    action":"Submitted","comment":"I have submitted for Approval"|"user":"UserName1","date":"Fri, 15 Dec 2017 12:31:03 GMT","
    action":"Submitted","comment":"This is rejected"}]'



 $hash = @{}
 $hash.'{' = ''
 $hash."'" = ""
 $hash.'}' = ''
 $hash.'[' = ''
 $hash.']' = ''
 $hash.'"' = ''

 Foreach ($key in $hash.Keys) {
    $testChars = $testChars.Replace($key, $hash.$key)
 }
 $testChars
