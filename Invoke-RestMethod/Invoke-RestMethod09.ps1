###GET
$Token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxMDIyIiwibmJmIjoxNzAyNDg3MzQ5LCJleHAiOjE3MDI2NjAxNDksImlhdCI6MTcwMjQ4NzM0OX0.-N_ppHZF0oqjJ8tfl3DvrrjanVerWOKQpO1VuvBavOk"
$URL = "http://localhost:5000/Post/GetMyPosts"
$headers = @{
    "Authorization" = "Bearer $Token"
    "Content-type"  = "application/json"
}
Invoke-RestMethod -Method GET -URI $URL -Headers $headers
##POST
$Token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxMDIyIiwibmJmIjoxNzAyNDg3MzQ5LCJleHAiOjE3MDI2NjAxNDksImlhdCI6MTcwMjQ4NzM0OX0.-N_ppHZF0oqjJ8tfl3DvrrjanVerWOKQpO1VuvBavOk"
$URL = "http://localhost:5000/Post/AddPost"
$headers = @{
    
    "Authorization" = "Bearer $Token"
    "Content-type"  = "application/json"
}
$body = @"
    {
        "postTitle": "SMARTPHONE",
        "postContent": "SAMSUNG GALAXY"
    }
"@
Invoke-RestMethod -Method POST -URI $URL -Headers $headers -body $body
