$ErrorActionPreference = "Stop"
Set-Location -Path $PSScriptRoot

.\codeformatter.ps1

if (!(git diff --quiet)) {
    git diff
    Write-Error "Formatting issues detected"
    exit 1
} else {
    Write-Host "Formatting OK"
}

$crlf = git grep -I "`r"
if ($crlf) {
    Write-Error "CRLF detected"
    exit 1
}