# fix_gradle.ps1
# Script to fix Gradle setup issues on Windows for Flutter + Android

# -----------------------------
# Configurable Gradle cache dir
# -----------------------------
$gradleCache = "D:\gradle_cache"

Write-Host "Setting Gradle home to $gradleCache"

# Set GRADLE_USER_HOME environment variable (system-wide)
setx GRADLE_USER_HOME "$gradleCache" /M | Out-Null

# -----------------------------
# Create Gradle folder if missing
# -----------------------------
if (-Not (Test-Path $gradleCache)) {
    Write-Host "Creating Gradle folder..."
    New-Item -ItemType Directory -Path $gradleCache | Out-Null
}

# -----------------------------
# Fix folder permissions
# -----------------------------
$user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
Write-Host "Setting full control permissions for user $user ..."
icacls $gradleCache /grant "${user}:(OI)(CI)F" /T

# -----------------------------
# JAVA_HOME check
# -----------------------------
if (-Not $env:JAVA_HOME) {
    Write-Host "⚠ JAVA_HOME is not set. Trying to auto-detect..."
    $javaPath = (Get-Command java.exe -ErrorAction SilentlyContinue).Source
    if ($javaPath) {
        $javaHome = (Split-Path (Split-Path $javaPath))
        Write-Host "Auto-detected Java at: $javaHome"
        setx JAVA_HOME "$javaHome" /M | Out-Null
        $env:JAVA_HOME = $javaHome
    } else {
        Write-Error "❌ Java not found! Please install JDK 11 or 17 and re-run."
        exit 1
    }
} else {
    Write-Host "JAVA_HOME is already set to: $env:JAVA_HOME"
}

# -----------------------------
# Run Gradle wrapper build
# -----------------------------
$projectPath = Read-Host "Enter your Flutter project path (e.g., D:\Projects\mygermanfreund)"
$androidPath = Join-Path $projectPath "android"

if (-Not (Test-Path $androidPath)) {
    Write-Error "❌ Invalid Flutter project path: $projectPath"
    exit 1
}

Set-Location $androidPath

if (-Not (Test-Path ".\gradlew.bat")) {
    Write-Error "❌ gradlew.bat not found in android/ folder."
    exit 1
}

Write-Host "Running Gradle wrapper build..."
try {
    & .\gradlew.bat build
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Gradle setup completed successfully!"
        Write-Host "You can now run 'flutter run' from your project root."
    } else {
        Write-Error "❌ Gradle build failed. Exit code: $LASTEXITCODE"
    }
} catch {
    Write-Error "❌ Gradle build failed. Check error above."
}
