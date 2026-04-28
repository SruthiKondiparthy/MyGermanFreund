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

| Screen / Feature | Description |
|---|---|
| **Home** | Dashboard with daily newcomer tips and quick navigation |
| **Letter Scanner** | Capture or upload a German letter (camera or gallery); on-device OCR via Google ML Kit |
| **Key info extraction** | Auto-extracts dates, deadlines, amounts, IBAN, reference numbers, emails, and phones from scanned text |
| **English translation** | Translates full scanned German text to English |
| **Bureaucracy Checklists** | Step-by-step checklists — Anmeldung, SIM card, bank account, Krankenkasse, Kita/School |
| **Mandatory Bureaucratic Tasks** | Priority task list with direct links to official resources |
| **Location Search** | WebView-powered search to find nearby Bürgeramt, banks, and other offices |
| **SIM Card Guide** | Guide to choosing a mobile provider in Germany |
| **Profile** | Phone/OTP verification with secure local storage |
| **About** | App overview and developer info |
| **PDF Viewer** | View PDF documents in-app |
| Login-free usage | Core features accessible without an account |
| **Web app** | [mygermanfreund.web.app](https://mygermanfreund.web.app/) — Firebase Hosting |

---

## 🔜 Upcoming Features

| Screen / Feature | Status |
|---|---|
| **AI Chat** — "Chat with your German Buddy" AI assistant | 🚧 Coming soon |
| **German Quiz** — interactive language learning quizzes | 🚧 Coming soon |
| **Job Search** — German job portals and CV preparation tips | 🚧 Coming soon |
| **Accommodation** — apartment and WG (shared flat) finder tips | 🚧 Coming soon |
| **Public Transport** — transit card guide and city transit apps | 🚧 Coming soon |
| **Settings** — app preferences and notification controls | 🚧 Coming soon |
| PDF letter upload support | 🗺️ Planned |
| Full offline / cloud OCR toggle | 🗺️ Planned |
| Multi-language UI (EN / DE / Easy German) | 🗺️ Planned |
| Saved checklists and user profiles | 🗺️ Planned |
| Push notifications for task deadlines | 🗺️ Planned |
| Community Q&A | 🗺️ Planned |
| Public API integrations (Bürgeramt availability, Kita portal) | 🗺️ Planned |
| **Freemium model** — free tier with core features; premium subscription for advanced tools | 🗺️ Planned |
| **Subscriptions** — in-app subscription management (billing, plan upgrades, cancellations) | 🗺️ Planned |

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
├── screens/
│   ├── home_screen.dart            # Dashboard + daily tips
│   ├── letter_scanner/             # LetterScannerPage, LetterResultPage
│   ├── Essentials/                 # ChecklistPage, ChecklistDetailPage
│   ├── mandatory_tasks_page.dart   # Priority task list with official links
│   ├── location_search_page.dart   # WebView-powered office search
│   ├── sim_card_page.dart          # SIM card provider guide
│   ├── german_buzz_page.dart       # Conversation starters
│   ├── profile_page.dart           # OTP phone auth + secure storage
│   ├── pdf_viewer_page.dart        # In-app PDF viewer
│   ├── chat_page.dart              # AI chat (coming soon)
│   ├── quiz_page.dart              # Language quiz (coming soon)
│   ├── job_search_page.dart        # Job search (coming soon)
│   ├── accommodation_page.dart     # Accommodation tips (coming soon)
│   └── public_transport_page.dart  # Transit guide (coming soon)
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

---

## 🌍 Web + API Expansion (Phase 1 delivery extension)

To support your request for a dedicated web experience and backend service layer beyond Flutter mobile:

- **TypeScript Web UI scaffold** added in `web-ui/` (React + Vite).
- **FastAPI backend scaffold** added in `backend-fastapi/` for guides, scanner quota/translation, premium summary gating, subscriptions, and German Buzz feeds.
- **Repository audit report** added in `docs/phase1_repository_audit.md` with implementation gap analysis and integration plan.

These additions are designed to align with the Flutter mobile feature set while moving entitlement and quota logic server-side for secure cross-platform behavior.

## 🚀 CI/CD and Docker

### GitHub Actions
- `CI` workflow (`.github/workflows/ci.yml`)
  - Runs FastAPI backend tests in `backend-fastapi/`.
  - Builds the TypeScript web app in `web-ui/`.
- `Docker Images` workflow (`.github/workflows/docker.yml`)
  - Builds Docker images for backend and web on PRs.
  - Pushes images to GitHub Container Registry on `main`/`master` pushes and tags.

### Docker images

#### Backend (FastAPI)
```bash
docker build -t mygermanfreund-backend:local ./backend-fastapi
docker run --rm -p 8000:8000 mygermanfreund-backend:local
```

#### Web UI (React/Vite static app on Nginx)
```bash
docker build -t mygermanfreund-web:local ./web-ui
docker run --rm -p 8080:80 mygermanfreund-web:local
```
