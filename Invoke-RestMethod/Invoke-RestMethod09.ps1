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
##PUT
$Token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxMDIyIiwibmJmIjoxNzAyNDg3MzQ5LCJleHAiOjE3MDI2NjAxNDksImlhdCI6MTcwMjQ4NzM0OX0.-N_ppHZF0oqjJ8tfl3DvrrjanVerWOKQpO1VuvBavOk"
$URL = "http://localhost:5000/Post/UpsertPost"
$headers = @{
    
    "Authorization" = "Bearer $Token"
    "Content-type"  = "application/json"
}
$body = @"
    {
        "postTitle": "COMPUTER",
        "postContent": "ThinkSmart"
    }
"@
Invoke-RestMethod -Method PUT -URI $URL -Headers $headers -body $body
##PUT
$Token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxMDIyIiwibmJmIjoxNzAyNDg3MzQ5LCJleHAiOjE3MDI2NjAxNDksImlhdCI6MTcwMjQ4NzM0OX0.-N_ppHZF0oqjJ8tfl3DvrrjanVerWOKQpO1VuvBavOk"
$URL = "http://localhost:5000/Post/UpsertPost"
$headers = @{
    
    "Authorization" = "Bearer $Token"
    "Content-type"  = "application/json"
}
$body = @"
    {
        "postId" : "7",
        "postTitle": "COMPUTER",
        "postContent": "Lenovo ThinkSmart"
    }
"@
Invoke-RestMethod -Method PUT -URI $URL -Headers $headers -body $body
##DELETE
$Token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxMDIyIiwibmJmIjoxNzAyNDg3MzQ5LCJleHAiOjE3MDI2NjAxNDksImlhdCI6MTcwMjQ4NzM0OX0.-N_ppHZF0oqjJ8tfl3DvrrjanVerWOKQpO1VuvBavOk"
$URL = "http://localhost:5000/Post/DeletePost/9"
$headers = @{
    
    "Authorization" = "Bearer $Token"
    "Content-type"  = "application/json"
}
Invoke-RestMethod -Method Delete -URI $URL -Headers $headers
