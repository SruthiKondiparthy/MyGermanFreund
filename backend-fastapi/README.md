# MyGermanFreund FastAPI Backend

This backend provides a Phase-1-aligned API surface for mobile and web clients.

## Run locally

```bash
cd backend-fastapi
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8000
```

## Key endpoints
- `GET /health`
- `GET /api/guides/`
- `GET /api/buzz/daily`
- `GET /api/scanner/quota/{user_id}`
- `POST /api/scanner/translate`
- `POST /api/scanner/summary/{user_id}` (premium-only)
- `GET /api/subscriptions/{user_id}`

## Notes
- This scaffold is intentionally lightweight and uses in-memory placeholder logic.
- Replace stubs with Firebase Auth verification and Firestore-backed persistence for production.
