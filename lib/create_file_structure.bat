@echo off

:: Create app.dart and firebase_options.dart if not present
if not exist "app.dart" type nul > "app.dart"
if not exist "firebase_options.dart" type nul > "firebase_options.dart"

:: Create common structure
md common\widgets
md common\utils

if not exist "common\constants.dart" type nul > "common\constants.dart"

:: Create features/auth structure
md features\auth\test
if not exist "features\auth\auth_service.dart" type nul > "features\auth\auth_service.dart"
if not exist "features\auth\auth_repository.dart" type nul > "features\auth\auth_repository.dart"
if not exist "features\auth\auth_gate.dart" type nul > "features\auth\auth_gate.dart"

:: Create features/scanner structure
md features\scanner\test
if not exist "features\scanner\scanner_service.dart" type nul > "features\scanner\scanner_service.dart"
if not exist "features\scanner\translator_service.dart" type nul > "features\scanner\translator_service.dart"
if not exist "features\scanner\date_extractor.dart" type nul > "features\scanner\date_extractor.dart"

:: Create features/checklists structure
md features\checklists\test
if not exist "features\checklists\checklist_model.dart" type nul > "features\checklists\checklist_model.dart"
if not exist "features\checklists\checklist_repository.dart" type nul > "features\checklists\checklist_repository.dart"
if not exist "features\checklists\checklist_page.dart" type nul > "features\checklists\checklist_page.dart"

:: Create features/notifications structure
md features\notifications\test
if not exist "features\notifications\notification_service.dart" type nul > "features\notifications\notification_service.dart"

:: Create features/topics structure
md features\topics\test
if not exist "features\topics\topics_repository.dart" type nul > "features\topics\topics_repository.dart"
if not exist "features\topics\topics_page.dart" type nul > "features\topics\topics_page.dart"

echo Folder and file structure created.
pause
