$ErrorActionPreference = "Stop"
$secret = Read-Host "Paste the Web OAuth client secret from Google Cloud (input is hidden)" -AsSecureString
if ($secret.Length -eq 0) {
    throw "The OAuth client secret cannot be empty."
}

$directory = Join-Path $env:LOCALAPPDATA "AaravisYumBox"
New-Item -ItemType Directory -Path $directory -Force | Out-Null
$path = Join-Path $directory "google-client-secret.dpapi"
$protectedSecret = ConvertFrom-SecureString $secret
[IO.File]::WriteAllText($path, $protectedSecret)
$secret.Dispose()
Write-Host "OAuth client secret saved encrypted for your Windows account at:"
Write-Host $path
Write-Host "The secret is outside the app folder and is never sent to the browser."
