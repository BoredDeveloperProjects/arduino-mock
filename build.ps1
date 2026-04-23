# build.ps1
$ErrorActionPreference = "Stop"

# Go to script directory
Set-Location -Path $PSScriptRoot

# Ensure dependencies (Scoop)
if (!(Get-Command cmake -ErrorAction SilentlyContinue)) {
    Write-Host "Installing cmake via Scoop..."
    scoop install cmake
}

if (!(Get-Command ninja -ErrorAction SilentlyContinue)) {
    Write-Host "Installing ninja via Scoop..."
    scoop install ninja
}

# Create build directory
if (!(Test-Path build)) {
    New-Item -ItemType Directory -Path build | Out-Null
}

Set-Location build

# Configure
cmake -DARDUINO_BOARD_LOGGER_BUILD_TESTS=ON -G Ninja ..

# Build
cmake --build .

# Run tests
ctest -V