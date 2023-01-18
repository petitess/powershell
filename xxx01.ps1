Set-ADUser jdoe -Replace @{thumbnailPhoto=([byte[]](Get-Content "C:\photos\jdoe_photo.jpg" -Encoding byte))}
