param (
    [string]$ExePath = ".\bernoulli.exe",
    [string]$DataPath = "bernoulli.data.json"
)

if (-not (Test-Path $ExePath)) {
    Write-Error "Executable not found at $ExePath"
    exit 1
}

if (-not (Test-Path $DataPath)) {
    Write-Warning "Data file not found at $DataPath. Commands might fail."
}

while ($true) {
    Write-Host "`n=== CmdStan Bernoulli Runner ===" -ForegroundColor Cyan
    Write-Host "1. Sample (MCMC)"
    Write-Host "2. Optimize (MLE)"
    Write-Host "3. Variational (ADVI)"
    Write-Host "4. Diagnose"
    Write-Host "Q. Quit"
    
    $selection = Read-Host "Select an option"

    switch ($selection) {
        "1" { 
            Write-Host "Running Sampling..." -ForegroundColor Green
            & $ExePath sample data file=$DataPath 
        }
        "2" { 
            Write-Host "Running Optimization..." -ForegroundColor Green
            & $ExePath optimize data file=$DataPath 
        }
        "3" { 
            Write-Host "Running Variational Inference..." -ForegroundColor Green
            & $ExePath variational data file=$DataPath 
        }
        "4" { 
            Write-Host "Running Diagnostics..." -ForegroundColor Green
            & $ExePath diagnose data file=$DataPath 
        }
        "Q" { exit }
        "q" { exit }
        Default { Write-Warning "Invalid selection" }
    }
}
