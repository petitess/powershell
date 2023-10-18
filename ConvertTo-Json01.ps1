$obj = @{
    "ObjectName1" = @{
        "Object1PropertyName1" = "Object1PropertyValue1"
        "Object1PropertyName2" = "Object1PropertyValue2"
    }
    "ObjectName2" = @{
        "Object2PropertyName1" = "Object2PropertyValue1"
        "Object2PropertyName2" = "Object2PropertyValue2"
    }
}

# Convert object to JSON
$json = $obj | ConvertTo-Json

# Save JSON to file
$json | Set-Content -Path C:\alkane\example.json
#############
#############
$json = @"
{
"Stuffs": 
    [
        {
            "Name": "Darts",
            "Type": "Fun Stuff"
        },

        {
            "Name": "Clean Toilet",
            "Type": "Boring Stuff"
        }
    ]
}
"@

$x = $json | ConvertFrom-Json

$x.Stuffs[0] # access to Darts
$x.Stuffs[1] # access to Clean Toilet
$darts = $x.Stuffs | where { $_.Name -eq "Darts" } #Darts
#############
#############
