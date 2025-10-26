# Vai nella root del progetto
cd "C:\Users\PALMA\OneDrive\Documents\Progetti\portfolio-assistant"

Write-Host ""
Write-Host "=== Verifica: pytest.ini ==="
if (Test-Path ".\pytest.ini") {
    Write-Host "pytest.ini trovato"
    $pytestContent = Get-Content .\pytest.ini
    if ($pytestContent -match "pythonpath\s*=\s*src") {
        Write-Host "Contiene pythonpath = src"
    } else {
        Write-Host "ATTENZIONE: pytest.ini non contiene pythonpath = src"
    }
} else {
    Write-Host "pytest.ini mancante"
}

Write-Host ""
Write-Host "=== Verifica: src/__init__.py ==="
if (Test-Path ".\src\__init__.py") {
    Write-Host "src/__init__.py trovato"
} else {
    Write-Host "src/__init__.py mancante"
}

Write-Host ""
Write-Host "=== Verifica: __init__.py nelle sottocartelle di src ==="
Get-ChildItem -Path ".\src" -Recurse -Directory | ForEach-Object {
    $initPath = Join-Path $_.FullName "__init__.py"
    $relative = $_.FullName.Substring((Get-Location).Path.Length + 1)
    if (Test-Path $initPath) {
        Write-Host "$relative contiene __init__.py"
    } else {
        Write-Host "$relative manca di __init__.py"
    }
}

Write-Host ""
Write-Host "=== Verifica: import locali non qualificati nei test ==="
$importiSospetti = 0
$moduliEsterni = @("fastapi", "pydantic", "tinydb", "datetime", "os", "re", "typing", "pytest", "json", "uuid", "math")

Get-ChildItem -Path ".\tests" -Recurse -Include *.py | ForEach-Object {
    $file = $_.FullName
    $lines = Get-Content $file
    foreach ($line in $lines) {
        if ($line -match "^from\s+(\w+)\s+import" -and $line -notmatch "^from\s+src\." -and ($matches[1] -notin $moduliEsterni)) {
            Write-Host "Import non qualificato in $file"
            Write-Host "    $line"
            $importiSospetti++
        }
    }
}

Write-Host ""
Write-Host "=== Verifica: working directory ==="
Write-Host ("Current directory: {0}" -f (Get-Location))

Write-Host ""
Write-Host "=== Riepilogo finale ==="
Write-Host ("Import sospetti da correggere: {0}" -f $importiSospetti)
Write-Host "Diagnostica completata."