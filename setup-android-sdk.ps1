# Android SDK: Downloads'taki commandlinetools'u M:\AndroidSDK'ya kopyala ve hazirla
# Lisans onayini siz yapacaksiniz (betik sonunda adim var).

$ErrorActionPreference = "Stop"
$sdkRoot = "M:\AndroidSDK"
$sourceDir = "C:\Users\UMUT\Downloads\commandlinetools-win-14742923_latest\cmdline-tools"

# 1. Kaynak kontrol
if (-not (Test-Path $sourceDir)) {
    Write-Error "Kaynak bulunamadi: $sourceDir"
    exit 1
}

# 2. M:\AndroidSDK\cmdline-tools\latest olustur ve kopyala
New-Item -ItemType Directory -Path "$sdkRoot\cmdline-tools\latest" -Force | Out-Null
Write-Host "Kopyalaniyor: $sourceDir -> $sdkRoot\cmdline-tools\latest"
Copy-Item -Path "$sourceDir\*" -Destination "$sdkRoot\cmdline-tools\latest" -Recurse -Force
Write-Host "Command-line tools kopyalandi."

# 3. ANDROID_HOME (kullanici)
[Environment]::SetEnvironmentVariable("ANDROID_HOME", $sdkRoot, "User")
$env:ANDROID_HOME = $sdkRoot
Write-Host "ANDROID_HOME = $sdkRoot (kullanici ortam degiskeni)"

# 4. sdkmanager ile platform-tools ve platform kur (lisans onayi SIZDE - betik burada kurmuyor)
$sdkmanager = "$sdkRoot\cmdline-tools\latest\bin\sdkmanager.bat"
if (-not (Test-Path $sdkmanager)) {
    Write-Warning "sdkmanager bulunamadi: $sdkmanager"
    exit 1
}

Write-Host ""
Write-Host "=============================================="
Write-Host "  SON ADIM (ONAY) - BUNU SIZ YAPACAKSINIZ"
Write-Host "=============================================="
Write-Host ""
Write-Host "1) Lisanslari onaylayin (her soruda y yazip Enter):"
Write-Host "   $sdkmanager --sdk_root=$sdkRoot --licenses"
Write-Host ""
Write-Host "2) Ardindan platform-tools ve platform kurun:"
Write-Host "   $sdkmanager --sdk_root=$sdkRoot --install `"platform-tools`" `"platforms;android-34`""
Write-Host ""
Write-Host "Yukaridaki iki komutu sirayla calistirin. ANDROID_HOME zaten ayarli."
Write-Host ""
