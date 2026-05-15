from fastapi import APIRouter

from app.services.content import get_guides_payload

router = APIRouter()


@router.get("/")
def list_guides() -> dict[str, list[dict[str, str | list[str]]]]:
    return {"guides": get_guides_payload()}
