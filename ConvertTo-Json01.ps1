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
