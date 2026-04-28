from fastapi import APIRouter

from app.services.entitlements import get_subscription_state

router = APIRouter()


@router.get("/{user_id}")
def subscription_state(user_id: str) -> dict[str, str | bool]:
    return get_subscription_state(user_id)
