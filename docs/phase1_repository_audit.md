# MyGermanFreund Repository Audit (Phase 1 + Web/FastAPI Expansion)

Date: 2026-04-28

## Scope audited
- Existing Flutter application structure and current feature delivery status.
- Readiness for adding a TypeScript-based web UI and a FastAPI backend alongside Flutter mobile.

## Current repository snapshot

### What already exists
- A working Flutter codebase with major screens already present for onboarding-style newcomer workflows, scanner, checklists, and German Buzz entry points.
- Firebase configuration is already wired into Flutter (`lib/firebase_options.dart`) and project metadata includes web platform assets.
- Core scanner pipeline elements exist in Flutter services (`ocr_service.dart`, `translation_service.dart`, `document_analyzer.dart`).

### Gaps relative to your requested Phase 1 target
1. **No dedicated TypeScript web application**
   - Current `web/` folder is Flutter web output shell, not a standalone product web client.
2. **No first-class backend service layer**
   - No Python/FastAPI service currently orchestrating auth-aware entitlements, scanner quotas, summaries, or German Buzz ingestion APIs.
3. **No formal API contract for web + mobile parity**
   - Flutter currently does most logic client-side; web/mobile shared backend contracts are not documented.
4. **No backend-centric subscription gate enforcement**
   - Needed for secure entitlement checks and premium-only summary generation.

## Recommended architecture (implemented in this PR)

### Frontend (new)
- `web-ui/`: React + TypeScript + Vite structure.
- App shell with core pages:
  - Landing (feature tabs/persona cards + German Buzz icon)
  - Guides (Anmeldung/Health Insurance/Banking)
  - Letter Scanner
  - Dashboard
- Shared localization bootstrap (EN/DE dictionary toggle placeholder, scalable to i18n framework).

### Backend (new)
- `backend-fastapi/`: FastAPI service with modular routers:
  - `auth`: stub profile endpoint.
  - `guides`: bilingual guide payload endpoint.
  - `scanner`: translate + quota status + premium summary endpoint gate.
  - `buzz`: daily bilingual content endpoint.
  - `subscriptions`: entitlement lookup endpoint.
- Service layer isolates core business logic:
  - quota checks
  - premium gating
  - static content assembly (placeholder for Firestore integration)

## Next integration steps
1. Wire Firebase Auth token verification in FastAPI middleware/dependency.
2. Replace in-memory/stub data with Firestore collections and scheduled ingestion workers for Buzz.
3. Connect scanner translation and summary endpoints to production providers.
4. Introduce shared API schema package (OpenAPI-generated TypeScript clients for Flutter web client + web-ui).
5. Add CI jobs for:
   - Python lint/test
   - TypeScript lint/build/test
   - contract checks (OpenAPI schema diff)

## Risk and mitigation
- **Risk:** Logic divergence between Flutter and new web app.
  - **Mitigation:** Move gating/entitlements/quotas to backend source-of-truth.
- **Risk:** Subscription bypass if checked only client side.
  - **Mitigation:** Enforce premium routes server-side and require verified user claims.
- **Risk:** Localization drift.
  - **Mitigation:** Keep ARB as source and generate web dictionaries from same localization pipeline.
