Set-Location "D:\Projects\mygermanfreund\android"; 
$build = Start-Process -FilePath ".\gradlew.bat" -ArgumentList "assembleDebug" -Wait -PassThru; 
if ($build.ExitCode -eq 0) {
    New-Item -ItemType Directory -Force -Path "D:\Projects\mygermanfreund\build\app\outputs\flutter-apk";
    Copy-Item "D:\Projects\mygermanfreund\android\app\build\outputs\apk\debug\app-debug.apk" "D:\Projects\mygermanfreund\build\app\outputs\flutter-apk\app-debug.apk" -Force;
    flutter run -d emulator-5554;
} else {
    Write-Host "APK build failed with exit code $($build.ExitCode)" -ForegroundColor Red;
}