$ErrorActionPreference = 'Stop'
Set-Location (Split-Path $PSScriptRoot -Parent)
if (-not (Get-Command cargo -ErrorAction SilentlyContinue)) { throw 'Rust/Cargo missing. Install from https://rustup.rs/' }
if (-not (Get-Command npm -ErrorAction SilentlyContinue)) { throw 'Node.js/npm missing. Install Node.js LTS.' }
npm install
if ($LASTEXITCODE -ne 0) { throw 'npm install failed' }
npm run build:nsis
if ($LASTEXITCODE -ne 0) { throw 'Tauri build failed' }
Write-Host 'Unsigned installer output: src-tauri\target\release\bundle\nsis\' -ForegroundColor Green
Write-Host 'Code signing is required for verified publisher identity; unsigned builds may trigger SmartScreen.' -ForegroundColor Yellow
