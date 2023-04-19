while (!(Test-Path -Path e:\file01.txt)) {
  try {
New-Item -Path e:\file01.txt -ItemType File -Force
  } catch {}
  Remove-Item -Path e:\file01.txt
}
