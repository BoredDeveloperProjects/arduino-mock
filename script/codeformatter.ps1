# codeformatter.ps1
$ErrorActionPreference = "Stop"
Set-Location -Path $PSScriptRoot

# Install astyle via scoop if missing
if (!(Get-Command astyle -ErrorAction SilentlyContinue)) {
    Write-Host "Installing astyle via Scoop..."
    scoop install astyle
}

# Check version (optional warning)
$version = astyle --version
if ($version -notmatch "2\.03") {
    Write-Warning "astyle version is not 2.03 (found: $version)"
}

# Format files
Get-ChildItem -Recurse -Include *.h, *.cc | ForEach-Object {
    astyle --mode=c `
        --style=java `
        --indent=spaces=2 `
        --indent-classes `
        --pad-oper $_.FullName
}

# Check CRLF (Windows-specific concern)
$crlfFiles = git grep -I "`r"
if ($crlfFiles) {
    Write-Error "CRLF detected. Please convert to LF."
    exit 1
}