# format_check.ps1
$ErrorActionPreference = "Stop"
Set-Location -Path $PSScriptRoot

# Run formatter
.\codeformatter.ps1

# Check for .orig files
$origFiles = Get-ChildItem -Recurse -Filter *.orig
if ($origFiles) {
    git diff
    Write-Error "Formatting issues detected. Run formatter locally."
    exit 1
}
else {
    Write-Host "Formatting OK"
}

# Check CRLF
$crlfFiles = git grep -I "`r"
if ($crlfFiles) {
    Write-Error "CRLF detected. Use LF line endings."
    exit 1
}
else {
    Write-Host "Line endings OK"
}