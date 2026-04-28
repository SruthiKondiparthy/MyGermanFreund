from fastapi import APIRouter, HTTPException

from app.models import ScanQuotaResponse, SummaryResponse, TranslationRequest, TranslationResponse
from app.services.entitlements import get_subscription_state
from app.services.scanner import get_monthly_scan_usage, summarize_text, translate_text

router = APIRouter()
FREE_MONTHLY_LIMIT = 3


@router.get("/quota/{user_id}", response_model=ScanQuotaResponse)
def scanner_quota(user_id: str) -> ScanQuotaResponse:
    subscription = get_subscription_state(user_id)
    used = get_monthly_scan_usage(user_id)
    is_premium = bool(subscription["premium"])
    limit = 999999 if is_premium else FREE_MONTHLY_LIMIT
    remaining = max(0, limit - used)
    return ScanQuotaResponse(monthly_limit=limit, used=used, remaining=remaining, premium=is_premium)


@router.post("/translate", response_model=TranslationResponse)
def translate(payload: TranslationRequest) -> TranslationResponse:
    translated = translate_text(payload.text, payload.source_lang, payload.target_lang)
    return TranslationResponse(translated_text=translated)


@router.post("/summary/{user_id}", response_model=SummaryResponse)
def summary(user_id: str, payload: TranslationRequest) -> SummaryResponse:
    subscription = get_subscription_state(user_id)
    if not subscription["premium"]:
        raise HTTPException(status_code=403, detail="Premium subscription required for summaries")

    return SummaryResponse(summary=summarize_text(payload.text))
