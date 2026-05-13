from fastapi import APIRouter, HTTPException
from app.models import (
    LetterAnalysisRequest,
    LetterAnalysisResponse,
    ScanQuotaResponse,
    SummaryResponse,
    TranslationRequest,
    TranslationResponse,
)
from app.services.entitlements import get_subscription_state
from app.services.scanner import (
    analyze_letter_with_claude,
    extract_amounts,
    extract_contact_info,
    extract_due_dates,
    extract_reference_numbers,
    get_monthly_scan_usage,
    summarize_text,
    translate_text,
)

router = APIRouter()
FREE_MONTHLY_LIMIT = 3


@router.get("/quota/{user_id}", response_model=ScanQuotaResponse)
def scanner_quota(user_id: str) -> ScanQuotaResponse:
    subscription = get_subscription_state(user_id)
    used = get_monthly_scan_usage(user_id)
    is_premium = bool(subscription["premium"])
    limit = 999999 if is_premium else FREE_MONTHLY_LIMIT
    remaining = max(0, limit - used)
    return ScanQuotaResponse(
        monthly_limit=limit,
        used=used,
        remaining=remaining,
        premium=is_premium
    )


@router.post("/translate", response_model=TranslationResponse)
def translate(payload: TranslationRequest) -> TranslationResponse:
    translated = translate_text(payload.text, payload.source_lang, payload.target_lang)
    return TranslationResponse(translated_text=translated)


@router.post("/summary/{user_id}", response_model=SummaryResponse)
def summary(user_id: str, payload: TranslationRequest) -> SummaryResponse:
    subscription = get_subscription_state(user_id)
    if not subscription["premium"]:
        raise HTTPException(
            status_code=403,
            detail="Premium subscription required for summaries"
        )
    return SummaryResponse(summary=summarize_text(payload.text))


@router.post("/analyze", response_model=LetterAnalysisResponse)
def analyze_letter(payload: LetterAnalysisRequest) -> LetterAnalysisResponse:
    subscription = get_subscription_state(payload.user_id)

    # Check quota for free users
    used = get_monthly_scan_usage(payload.user_id)
    is_premium = bool(subscription["premium"])
    if not is_premium and used >= FREE_MONTHLY_LIMIT:
        raise HTTPException(
            status_code=429,
            detail="Monthly scan limit reached. Upgrade to premium for unlimited scans."
        )

    # Validate input
    if not payload.ocr_text or len(payload.ocr_text.strip()) < 20:
        raise HTTPException(
            status_code=400,
            detail="Text too short. Please scan a valid German document."
        )

    try:
        # Call Claude API for intelligent analysis
        claude_result = analyze_letter_with_claude(payload.ocr_text)

        # Validate it's actually a German document
        if not claude_result.get("is_german_document", True):
            raise HTTPException(
                status_code=400,
                detail="This does not appear to be a German document. Please scan a German official letter."
            )

        return LetterAnalysisResponse(
            original_text=payload.ocr_text,
            translated_text=claude_result.get("translated_text", ""),
            summary=claude_result.get("summary", ""),
            due_dates=claude_result.get("due_dates", []),
            amounts=claude_result.get("amounts", []),
            contact_info=claude_result.get("contact_info", []),
            reference_numbers=claude_result.get("reference_numbers", []),
            premium=is_premium,
            subject=claude_result.get("subject", ""),           # NEW!!
            letter_date=claude_result.get("letter_date", ""),   # NEW!!
            has_payment_due=claude_result.get("has_payment_due", False),  # NEW!!
            document_type=claude_result.get("document_type", ""),
            urgency=claude_result.get("urgency", "LOW"),
            sender=claude_result.get("sender", ""),
            action_required=claude_result.get("action_required", ""),
        )

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Analysis failed: {str(e)}"
        )