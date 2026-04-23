# MyGermanFreund

> A companion app for newcomers in Germany — letter scanning, bureaucracy checklists, and cultural conversation starters.

🌐 **Live app:** [https://mygermanfreund.web.app/](https://mygermanfreund.web.app/)

---

## 🤖 How AI Is Used in This Project

AI drives both the **development workflow** and the **product experience**:

**Development workflow**
- GitHub Copilot accelerates feature implementation — OCR pipelines, regex extraction logic, and UI scaffolding were iterated rapidly using AI pair-programming.
- AI-assisted code review catches edge cases (e.g., OOM on large images, async `mounted` guards) before they reach production.
- Prompt-driven architecture decisions: feature scoping, fallback UX flows (e.g., doc scanner → camera/gallery graceful degradation), and tech-stack trade-offs were refined through AI consultation.

**Product features**
- **On-device OCR** (Google ML Kit) extracts text from German official letters — no server round-trip needed.
- **Regex-based document analysis** (`DocumentAnalyzer`) extracts dates, deadlines, amounts, IBAN, reference numbers, and contact details from raw OCR output.
- **Translation pipeline** converts extracted German text to English, making bureaucratic letters immediately actionable for newcomers.

---

## ✅ Features Available Now

| Feature | Status |
|---|---|
| **Letter Scanner** — capture or upload a letter image (camera or gallery) | ✅ Available |
| **OCR text extraction** — on-device via Google ML Kit | ✅ Available |
| **Key info extraction** — dates, deadlines, amounts, IBAN, reference numbers, emails, phones | ✅ Available |
| **English translation** of scanned German text | ✅ Available |
| **Bureaucracy Checklists** — Anmeldung, SIM card, bank account, Krankenkasse, Kita/School | ✅ Available |
| **German Buzz** — curated simple-language conversation starters | ✅ Available |
| Login-free usage | ✅ Available |
| Web app (Firebase Hosting) | ✅ [mygermanfreund.web.app](https://mygermanfreund.web.app/) |

---

## 🗺️ Planned

- PDF letter upload support
- Full offline / cloud OCR toggle
- Multi-language UI (EN / DE / Easy German)
- Saved checklists and user profiles
- Push notifications for task deadlines
- Community Q&A
- Public API integrations (Bürgeramt, Kita portal)

---

## 🏗️ Technical Specifications

| Layer | Technology |
|---|---|
| **Frontend** | Flutter (Dart) — cross-platform (Android primary, web via Firebase Hosting) |
| **Backend / Infra** | Firebase (Hosting, Auth-ready, Firestore-ready) |
| **OCR** | Google ML Kit — `google_mlkit_text_recognition` (on-device, Latin script) |
| **Document analysis** | Custom Dart (`DocumentAnalyzer`) — regex extraction for German letter patterns |
| **Translation** | `translator` package (Dart); architecture supports swap to DeepL / Cloud Translate |
| **Image input** | `image_picker` — camera capture + gallery upload; images downscaled to 2000 px max to prevent OOM |
| **State management** | Flutter built-in (`setState`); structured for easy migration to Riverpod/Bloc |
| **CI / Hosting** | Firebase CLI + GitHub Actions (Firebase Hosting deploy) |

**Project layout (key paths)**
```
lib/
├── screens/letter_scanner/   # LetterScannerPage, LetterResultPage
├── services/                 # OcrService, DocumentAnalyzer, TranslationService
├── theme/                    # AppColors
assets/                       # Static assets
```

---

## ⚙️ Local Setup

```bash
git clone https://github.com/SruthiKondiparthy/MyGermanFreund.git
cd MyGermanFreund
flutter pub get
# Add android/app/google-services.json from your Firebase project
flutter run
```

---

## 🤝 Contributing

Issues and pull requests are welcome. Please open an issue first to discuss larger changes.

## 📝 License

MIT (see LICENSE file)

## 👩‍💻 Developer

Built by **Sruthi Ravuru** — software engineer and product developer passionate about helping newcomers thrive in Germany.
