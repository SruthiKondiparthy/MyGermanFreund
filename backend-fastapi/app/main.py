from fastapi import FastAPI

from app.routers import auth, buzz, guides, scanner, subscriptions

app = FastAPI(title="MyGermanFreund API", version="0.1.0")

app.include_router(auth.router, prefix="/api/auth", tags=["auth"])
app.include_router(guides.router, prefix="/api/guides", tags=["guides"])
app.include_router(scanner.router, prefix="/api/scanner", tags=["scanner"])
app.include_router(subscriptions.router, prefix="/api/subscriptions", tags=["subscriptions"])
app.include_router(buzz.router, prefix="/api/buzz", tags=["buzz"])


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}
