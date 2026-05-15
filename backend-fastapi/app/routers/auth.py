from fastapi import APIRouter

router = APIRouter()


@router.get("/me")
def me() -> dict[str, str]:
    return {"user_id": "demo-user", "email": "demo@example.com"}
