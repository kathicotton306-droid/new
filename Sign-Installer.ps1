param(
  [Parameter(Mandatory=$true)][string]$InstallerPath,
  [Parameter(Mandatory=$true)][string]$CertificateThumbprint
)
$ErrorActionPreference = 'Stop'
$installer = (Resolve-Path $InstallerPath).Path
if (-not (Get-Command signtool.exe -ErrorAction SilentlyContinue)) {
  throw 'signtool.exe not found. Install the Windows SDK signing tools and reopen the terminal.'
}
& signtool.exe sign /sha1 $CertificateThumbprint /fd SHA256 /tr http://timestamp.digicert.com /td SHA256 $installer
if ($LASTEXITCODE -ne 0) { throw 'Signing failed. Confirm certificate is trusted and private key is available.' }
& signtool.exe verify /pa /v $installer
if ($LASTEXITCODE -ne 0) { throw 'Signature verification failed.' }
Write-Host 'Installer signed and verified. SmartScreen may still require reputation.' -ForegroundColor Green
