$ErrorActionPreference = "Stop"

Set-Location -Path $PSScriptRoot

& .\codeformatter.ps1
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

git diff --quiet -- .
$diffExitCode = $LASTEXITCODE

if ($diffExitCode -eq 1) {
    Write-Host ""
    Write-Host "[ERROR] Formatting issues were found and auto-corrected."
    Write-Host "[INFO] The commit was stopped so you can review the formatting changes."
    Write-Host "[INFO] Next steps:"
    Write-Host "  1. Review the diff"
    Write-Host "  2. Stage the updated files"
    Write-Host "  3. Re-run the commit"
    Write-Host ""
    Write-Host "[INFO] Suggested commands:"
    Write-Host "  git diff"
    Write-Host "  git add ."
    Write-Host '  git commit -m "your message"'
    Write-Host ""
    Write-Host "[INFO] Formatting diff:"
    git diff -- .
    exit 1
}
elseif ($diffExitCode -ne 0) {
    Write-Error "Unable to check formatting diff."
    exit $diffExitCode
}

Write-Host "[INFO] Formatting OK"

$crlfOutput = git grep --cached -I ([char]13) 2>$null
$crlfExitCode = $LASTEXITCODE

if ($crlfExitCode -eq 0) {
    Write-Host $crlfOutput
    Write-Error "Do not use CRLF. Use LF."
    exit 1
}
elseif ($crlfExitCode -ne 1) {
    Write-Error "Unable to check staged files for CRLF line endings."
    exit $crlfExitCode
}

Write-Host "[INFO] Formatting and CRLF checks passed"

exit 0
