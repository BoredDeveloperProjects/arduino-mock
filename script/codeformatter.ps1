$ErrorActionPreference = "Stop"

Write-Host "[INFO] Starting formatter..."

if (-not (Get-Command clang-format -ErrorAction SilentlyContinue)) {
    Write-Host "[ERROR] clang-format not found"
    Write-Host "[INFO] Install it with:"
    Write-Host "  scoop install llvm"
    exit 1
}

$repoRoot = (git rev-parse --show-toplevel).Trim()
if (-not $repoRoot) {
    Write-Error "Not inside a git repository"
    exit 1
}

Set-Location -Path $repoRoot
Write-Host "[INFO] Repo root: $repoRoot"

# Collect tracked + untracked (but not ignored) source files, relative to repo root.
# Relative paths are important so .clang-format-ignore can match correctly.
$files = @(
    git ls-files --cached --others --exclude-standard -- '*.h' '*.cc' '*.cpp'
) | Where-Object { $_ -and $_.Trim() -ne "" } | Sort-Object -Unique

if (-not $files -or $files.Count -eq 0) {
    Write-Host "[INFO] No matching files found"
    exit 0
}

Write-Host "[INFO] Found $($files.Count) file(s) to format"

if ($PSVersionTable.PSVersion.Major -ge 7) {
    Write-Host "[INFO] Using parallel formatting (PowerShell 7+)"

    $files | ForEach-Object -Parallel {
        $relativePath = $_ -replace '\\', '/'
        Write-Host "[FORMAT] $relativePath"
        & clang-format -i $relativePath
        if ($LASTEXITCODE -ne 0) {
            throw "clang-format failed for $relativePath"
        }
    } -ThrottleLimit 8
}
else {
    Write-Host "[INFO] PowerShell 7+ not detected, using sequential fallback"

    foreach ($file in $files) {
        $relativePath = $file -replace '\\', '/'
        Write-Host "[FORMAT] $relativePath"
        & clang-format -i $relativePath
        if ($LASTEXITCODE -ne 0) {
            Write-Error "clang-format failed for $relativePath"
            exit 1
        }
    }
}

Write-Host "[INFO] Formatting complete"

Write-Host "[INFO] Checking staged files for CRLF line endings..."
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

Write-Host "[INFO] CRLF check passed"
Write-Host "[INFO] Done"
exit 0
