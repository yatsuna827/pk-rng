$ErrorActionPreference = "Stop"

$ExePath = Join-Path $PSScriptRoot "_build\native\debug\build\pk_rng_lcg32_cli.exe"
$BinDir = Join-Path $env:USERPROFILE "bin"
$DestPath = Join-Path $BinDir "lcg32.exe"

if (-not (Test-Path $ExePath)) {
    Write-Host "Error: 実行ファイルが見つかりません: $ExePath" -ForegroundColor Red
    Write-Host "先に 'moon build' を実行してください。" -ForegroundColor Yellow
    exit 1
}

if (-not (Test-Path $BinDir)) {
    Write-Host "Creating $BinDir ..." -ForegroundColor Cyan
    New-Item -ItemType Directory -Force -Path $BinDir | Out-Null
}

Write-Host "Copying executable to $DestPath ..." -ForegroundColor Cyan
Copy-Item -Path $ExePath -Destination $DestPath -Force

$CurrentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($CurrentPath -notlike "*$BinDir*") {
    Write-Host "Adding $BinDir to PATH ..." -ForegroundColor Cyan
    [Environment]::SetEnvironmentVariable("Path", "$CurrentPath;$BinDir", "User")
    Write-Host "PATH updated. Please restart your terminal." -ForegroundColor Yellow
} else {
    Write-Host "PATH already contains $BinDir" -ForegroundColor Green
}

Write-Host ""
Write-Host "Installation complete!" -ForegroundColor Green
Write-Host "Command: lcg32" -ForegroundColor Cyan
