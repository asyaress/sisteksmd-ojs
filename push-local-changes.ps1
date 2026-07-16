param(
    [string]$Message = "Sync local OJS changes",
    [string]$Remote = "origin",
    [string]$Branch = "main",
    [switch]$IncludeRuntimeFiles
)

$ErrorActionPreference = "Stop"

Set-Location -LiteralPath $PSScriptRoot

if (-not (Test-Path -LiteralPath ".git")) {
    throw "Folder ini bukan root repository Git: $PSScriptRoot"
}

Write-Host "Repository : $PSScriptRoot"
Write-Host "Remote     : $Remote"
Write-Host "Branch     : $Branch"
Write-Host "Message    : $Message"
Write-Host ""

$currentBranch = (git branch --show-current).Trim()
if ($currentBranch -ne $Branch) {
    Write-Host "Branch aktif saat ini: $currentBranch"
    Write-Host "Script akan push ke: $Branch"
    $confirmBranch = Read-Host "Lanjut? ketik YES"
    if ($confirmBranch -ne "YES") {
        throw "Dibatalkan karena branch tidak sesuai."
    }
}

Write-Host "Membersihkan staged area lama..."
git restore --staged . 2>$null

Write-Host "Mengambil status perubahan..."
$status = git status --short
if (-not $status) {
    Write-Host "Tidak ada perubahan untuk dipush."
    exit 0
}

$runtimePatterns = @(
    " config.inc.php",
    " cache/",
    " cache\",
    " local-snapshot/",
    " local-snapshot\",
    " files/",
    " files\"
)

$runtimeMatches = @()
foreach ($line in $status) {
    foreach ($pattern in $runtimePatterns) {
        if ($line.Contains($pattern)) {
            $runtimeMatches += $line
            break
        }
    }
}

if ($runtimeMatches.Count -gt 0 -and -not $IncludeRuntimeFiles) {
    Write-Host ""
    Write-Host "File runtime/sensitif terdeteksi dan TIDAK akan distage otomatis:"
    $runtimeMatches | Select-Object -First 80 | ForEach-Object { Write-Host "  $_" }
    if ($runtimeMatches.Count -gt 80) {
        Write-Host "  ... dan $($runtimeMatches.Count - 80) item lainnya"
    }
    Write-Host ""
    Write-Host "Kalau benar-benar mau ikutkan semua file runtime juga, jalankan:"
    Write-Host "  .\push-local-changes.ps1 -IncludeRuntimeFiles -Message `"$Message`""
    Write-Host ""
}

Write-Host "Stage perubahan..."
if ($IncludeRuntimeFiles) {
    git config core.longpaths true
    git add -A
} else {
    $safePathspecs = @(
        ".",
        ":!config.inc.php",
        ":!cache",
        ":!cache/**",
        ":!local-snapshot",
        ":!local-snapshot/**",
        ":!files",
        ":!files/**"
    )

    git add -A -- $safePathspecs
}

$staged = git diff --cached --name-only
if (-not $staged) {
    Write-Host "Tidak ada file staged setelah filter pengaman."
    exit 0
}

Write-Host ""
Write-Host "File yang akan dicommit:"
$staged | Select-Object -First 120 | ForEach-Object { Write-Host "  $_" }
if ($staged.Count -gt 120) {
    Write-Host "  ... dan $($staged.Count - 120) file lainnya"
}
Write-Host ""

$dangerStaged = $staged | Where-Object {
    $_ -eq "config.inc.php" -or
    $_ -like "cache/*" -or
    $_ -like "local-snapshot/*" -or
    $_ -like "files/*"
}

if ($dangerStaged -and -not $IncludeRuntimeFiles) {
    throw "Ada file runtime/sensitif yang masih staged. Dibatalkan."
}

$confirm = Read-Host "Commit dan push file staged di atas? ketik YES"
if ($confirm -ne "YES") {
    git restore --staged . 2>$null
    throw "Dibatalkan. Staged area sudah dibersihkan."
}

Write-Host "Commit..."
git commit -m $Message

Write-Host "Push..."
git push $Remote $Branch

Write-Host ""
Write-Host "Selesai. Commit terakhir:"
git log --oneline -1
