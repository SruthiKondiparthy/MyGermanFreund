📘 README.md — MyGermanFreund

A companion app for newcomers in Germany: checklists, letter scanning, and cultural insights.

🇩🇪 About MyGermanFreund

MyGermanFreund is a mobile app designed to help newcomers in Germany navigate bureaucracy, understand official letters, and stay updated on German daily life.
The goal is to make settling in easier by providing:

📄 AI-powered Letter Scanning (OCR + translation + summarization)

📝 Step-by-step Checklists for Anmeldung, Kitas, Health Insurance, etc.

🗞️ German Buzz – trending news simplified for conversational use

🔍 Beginner-friendly, login-free usage for maximum accessibility

📱 Modern Flutter UI for Android (iOS later)

🚀 Phase 1 Scope

The first release focuses on core utility features:

✔️ 1. Letter Scanner (Prototype)

Capture or upload letters

Extract text using OCR

Translate to English or Easy German

Provide a short summary

Quick "Important dates" extraction (coming soon)

✔️ 2. Bureaucratic Checklists

Step-by-step guides for:
✔ Anmeldung
✔ Getting a SIM card
✔ Opening a bank account
✔ Krankenkasse registration
✔ Kita / School registration

No login required

Optimized for newcomers

✔️ 3. German Buzz

Curated simple-language “topic starters”

Useful for workplace/school conversations

🏗️ Tech Stack
Frontend

Flutter (Dart)

Clean screen structure & theming

State management: (Basic set, can expand later)

Backend

Firebase (Auth, Storage, Firestore planned)

OCR: Google ML Kit (local)

Translation: API-ready structure (OpenAI/DeepL later)

📱 App Structure
lib/
├── main.dart
├── screens/
│   ├── letter_scanner/
│   │    ├── letter_scanner_page.dart
│   │    ├── letter_result_page.dart
│   ├── german_buzz_page.dart
│   ├── home_screen.dart
│   ├── mandatory_tasks_page.dart
├── services/
│   ├── ocr_service.dart
│   ├── translation_service.dart
│   ├── document_analyzer.dart
├── widgets/
├── theme/
│   └── app_colors.dart

⚙️ Setup Instructions
1️⃣ Clone the repo
git clone <your-repo-url>
cd mygermanfreund

2️⃣ Install dependencies
flutter pub get

3️⃣ Configure Firebase

Create a Firebase project

Add Android app

Download google-services.json

Place it in: android/app/

Add Firebase dependencies in android/app/build.gradle.kts

4️⃣ Run the app
flutter run

🧪 Testing (Upcoming)

Unit tests for OCR parsing

UI widget tests

Integration tests (letter upload → translation → result)

🛣️ Roadmap
Phase 1 (Current)

Core navigation

Letter scanner prototype

Onboarding checklists

German Buzz feed

Phase 2

Local & cloud OCR switch

Full translation support

Smart deadlines detection

PDF letter support

Multi-language UI (EN, DE, Easy DE)

Phase 3

Profiles & saved checklists

Community Q&A

Push notifications for tasks

Integration with public APIs
(Bürgeramt availability, Kita portal info)

🤝 Contributing

Contributions, ideas, and feedback are welcome!
Open an issue or create a pull request.

📝 License

MIT License (to be added if open-source)

👩‍💻 About the Developer

MyGermanFreund is built by Sruthi Ravuru,
a software engineer + product developer passionate about improving the lives of newcomers in Germany.
