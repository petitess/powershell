function Convert-ObjectIdToSid
{
    param([String] $ObjectId)

    $d=[UInt32[]]::new(4);
[Buffer]::BlockCopy([Guid]::Parse($ObjectId).ToByteArray(),0,$d,0,16);"S-1-12-1-$d".Replace(' ','-')
}

Convert-ObjectIdToSid -ObjectId "93234823-d605-43e1-95be-xxxx"
