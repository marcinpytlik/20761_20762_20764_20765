param(
    [Parameter(Mandatory = $true)]
    [string]$FileId,            # ID pliku z Google Drive

    [Parameter(Mandatory = $true)]
    [string]$BackupName,        # Nazwa pliku wynikowego, np. AdventureWorks2022.bak

    [string]$BackupDir          # <- bez domyślnej wartości tutaj
)

Write-Host "=== SQLManiak Backup Downloader ===" -ForegroundColor Cyan

# Jeśli nie podano BackupDir – ustaw na ..\backups względem katalogu skryptu
if (-not $BackupDir) {
    # $PSScriptRoot = katalog, w którym leży ten skrypt (scripts)
    $repoRoot  = Split-Path $PSScriptRoot -Parent   # katalog wyżej = root repo
    $BackupDir = Join-Path $repoRoot "backups"
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

$downloadUrl = "https://drive.google.com/uc?export=download&id=$FileId"

Write-Host "Pobieram plik z:"
Write-Host "  $downloadUrl"
Write-Host ""
Write-Host "Zapis do: $destinationPath"
Write-Host ""

Invoke-WebRequest -Uri $downloadUrl -OutFile $destinationPath -UseBasicParsing
Write-Host "✅ Pobieranie zakończone." -ForegroundColor Green
