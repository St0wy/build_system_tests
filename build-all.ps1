# Build Everything
Write-Host "Building everything..."

if (-not (Test-Path -Path "bin")) {
    New-Item -ItemType Directory -Path "bin"
}

Push-Location "stowy_physics_engine"
Invoke-Expression ".\build.ps1 $args"
Pop-Location
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error:$LASTEXITCODE"
    exit
}

Push-Location "testbed"
Invoke-Expression ".\build.ps1 $args"
Pop-Location
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error:$LASTEXITCODE"
    exit
}

Write-Host "All assemblies built successfully."