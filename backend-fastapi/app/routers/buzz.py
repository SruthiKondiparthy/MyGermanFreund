from fastapi import APIRouter

from app.services.content import get_buzz_payload

router = APIRouter()


@router.get("/daily")
def daily_buzz() -> dict[str, dict[str, str]]:
    return get_buzz_payload()
