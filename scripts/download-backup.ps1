param(
    [Parameter(Mandatory = $true)]
    [string]$FileId,            # ID pliku z Google Drive

    [Parameter(Mandatory = $true)]
    [string]$BackupName,        # Nazwa pliku wynikowego, np. AdventureWorks2022.bak

    [string]$BackupDir = "backups"
)

Write-Host "=== SQLManiak Backup Downloader ===" -ForegroundColor Cyan
Write-Host "FileId     : $FileId"
Write-Host "BackupName : $BackupName"
Write-Host "BackupDir  : $BackupDir"
Write-Host ""

# Upewnij się, że katalog backups istnieje
if (-not (Test-Path $BackupDir)) {
    Write-Host "Tworzę katalog '$BackupDir'..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $BackupDir | Out-Null
}

$destinationPath = Join-Path $BackupDir $BackupName

# Direct download link z Google Drive
$downloadUrl = "https://drive.google.com/uc?export=download&id=$FileId"

Write-Host "Pobieram plik z:"
Write-Host "  $downloadUrl"
Write-Host ""
Write-Host "Zapis do: $destinationPath"
Write-Host ""

try {
    Invoke-WebRequest -Uri $downloadUrl -OutFile $destinationPath -UseBasicParsing
    Write-Host "✅ Pobieranie zakończone." -ForegroundColor Green

    if (Test-Path $destinationPath) {
        $fileInfo = Get-Item $destinationPath
        Write-Host "Rozmiar pliku: $($fileInfo.Length / 1MB -as [int]) MB"
    }
}
catch {
    Write-Host "❌ Błąd podczas pobierania backupu:" -ForegroundColor Red
    Write-Host $_.Exception.Message
    exit 1
}
