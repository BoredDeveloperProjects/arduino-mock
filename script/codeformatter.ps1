# codeformatter.ps1
$ErrorActionPreference = "Stop"
Set-Location -Path $PSScriptRoot

if (!(Get-Command clang-format -ErrorAction SilentlyContinue)) {
    Write-Host "Installing clang-format via Scoop..."
    scoop install llvm
}

Get-ChildItem -Recurse -Include *.h,*.cc,*.cpp | ForEach-Object {
    clang-format -i $_.FullName
}

# CRLF check
$crlf = git grep -I "`r"
if ($crlf) {
    Write-Error "CRLF detected. Use LF."
    exit 1
}