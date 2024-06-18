azcopy login --tenant-id ""
1..100 | ForEach-Object {
    azcopy copy "https://stabc01.blob.core.windows.net/backup-source/delta-test/files01/*" "https://stabc01.blob.core.windows.net/backup-source/delta-test/files$($_)" --recursive=true
}
