Write-Host "Starting Solution Center build..."

$projectPath = "..\project\FlashLogin.project"
$outputFolder = "..\bin"

if (!(Test-Path $outputFolder)) {
    New-Item -ItemType Directory -Path $outputFolder
}

$solutionCenterCLI = "C:\Program Files\SolutionCenter\bin\SolutionCenterCLI.exe"

& "$solutionCenterCLI" build $projectPath --output $outputFolder

if ($LASTEXITCODE -ne 0) {
    Write-Host "Build Failed"
    exit 1
}

Write-Host "Build Completed Successfully"