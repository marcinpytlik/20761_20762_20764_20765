param(
    [string]$FileId,            # ID pliku z Google Drive (opcjonalnie)
    [string]$Url,               # Pełny link "Udostępnij" z Google Drive (opcjonalnie)

    [Parameter(Mandatory = $true)]
    [string]$BackupName,        # Nazwa pliku wynikowego, np. AdventureWorks2022.bak

    [string]$BackupDir          # zostaw pusty, policzymy poniżej
)

Write-Host "=== SQLManiak Backup Downloader ===" -ForegroundColor Cyan

# Jeśli nie podano BackupDir – ustaw na ..\backups względem katalogu skryptu
if (-not $BackupDir) {
    $repoRoot  = Split-Path $PSScriptRoot -Parent   # katalog wyżej = root repo
    $BackupDir = Join-Path $repoRoot "backups"
}

# Jeśli nie ma FileId, ale jest Url – wyciągnij FileId z URL
if (-not $FileId -and $Url) {
    # Szukamy fragmentu /d/<ID>/
    if ($Url -match "/d/([^/]+)") {
        $FileId = $matches[1]
        Write-Host "Wyciągnięty FileId z URL: $FileId"
    }
    else {
        Write-Host "❌ Nie udało się wyciągnąć FileId z podanego URL." -ForegroundColor Red
        exit 1
    }
}

if (-not $FileId) {
    Write-Host "❌ Musisz podać albo -FileId, albo -Url." -ForegroundColor Red
    exit 1
}

Write-Host "FileId     : $FileId"
Write-Host "BackupName : $BackupName"
Write-Host "BackupDir  : $BackupDir"
Write-Host ""

if (-not (Test-Path $BackupDir)) {
    Write-Host "Tworzę katalog '$BackupDir'..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $BackupDir | Out-Null
}

$destinationPath = Join-Path $BackupDir $BackupName

# Direct download link
$downloadUrl = "https://drive.google.com/uc?export=download&id=$FileId"

Write-Host "Pobieram plik z:"
Write-Host "  $downloadUrl"
Write-Host ""
Write-Host "Zapis do: $destinationPath"
Write-Host ""

Invoke-WebRequest -Uri $downloadUrl -OutFile $destinationPath -UseBasicParsing
Write-Host "✅ Pobieranie zakończone." -ForegroundColor Green
