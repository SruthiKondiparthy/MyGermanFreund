from fastapi import APIRouter, HTTPException
from app.models import (
    DetailedAnalysisRequest,
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
    deep_analyze_letter_with_claude,
    extract_amounts,
    extract_contact_info,
    extract_due_dates,
    extract_reference_numbers,
    get_monthly_scan_usage,
    increment_scan_usage,
    summarize_text,
    translate_text,
    validate_is_german_document,
)
import logging

logger = logging.getLogger("mygermanfreund.scanner")

router = APIRouter()
FREE_MONTHLY_LIMIT = 3


# ─── Quota ───────────────────────────────────────────────────────────────────
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
        premium=is_premium,
    )


# ─── Translate ────────────────────────────────────────────────────────────────
@router.post("/translate", response_model=TranslationResponse)
def translate(payload: TranslationRequest) -> TranslationResponse:
    translated = translate_text(payload.text, payload.source_lang, payload.target_lang)
    return TranslationResponse(translated_text=translated)


# ─── Summary (Premium) ────────────────────────────────────────────────────────
@router.post("/summary/{user_id}", response_model=SummaryResponse)
def summary(user_id: str, payload: TranslationRequest) -> SummaryResponse:
    subscription = get_subscription_state(user_id)
    if not subscription["premium"]:
        raise HTTPException(
            status_code=403,
            detail="Premium subscription required for summaries",
        )
    return SummaryResponse(summary=summarize_text(payload.text))


# ─── Analyze ──────────────────────────────────────────────────────────────────
@router.post("/analyze", response_model=LetterAnalysisResponse)
def analyze_letter(payload: LetterAnalysisRequest) -> LetterAnalysisResponse:

    # Check quota
    subscription = get_subscription_state(payload.user_id)
    used = get_monthly_scan_usage(payload.user_id)
    is_premium = bool(subscription["premium"])

    if not is_premium and used >= FREE_MONTHLY_LIMIT:
        raise HTTPException(
            status_code=429,
            detail=f"Monthly limit of {FREE_MONTHLY_LIMIT} scans reached. Upgrade to premium!",
        )

    if not payload.ocr_text or len(payload.ocr_text.strip()) < 20:
        raise HTTPException(
            status_code=400,
            detail="Text too short. Please scan a valid German document.",
        )

    try:
        # Step 1: Haiku validation — CHEAP!!
        logger.info(f"Validating document for user {payload.user_id}")
        validation = validate_is_german_document(payload.ocr_text)

        if not validation.get("is_valid", True):
            raise HTTPException(
                status_code=400,
                detail="This doesn't appear to be a German document. Please scan a German letter.",
            )

        # Step 2: Sonnet analysis — with language!!
        logger.info(f"Analysing in language: {payload.output_language}")
        claude_result = analyze_letter_with_claude(
            ocr_text=payload.ocr_text,
            output_language=payload.output_language.value,
        )

        # Increment usage after successful scan!!
        increment_scan_usage(payload.user_id)

        return LetterAnalysisResponse(
            original_text=payload.ocr_text,
            translated_text=claude_result.get("translated_text", ""),
            summary=claude_result.get("summary", ""),
            due_dates=claude_result.get("due_dates", []),
            amounts=claude_result.get("amounts", []),
            contact_info=claude_result.get("contact_info", []),
            reference_numbers=claude_result.get("reference_numbers", []),
            premium=is_premium,
            subject=claude_result.get("subject", ""),
            letter_date=claude_result.get("letter_date", ""),
            has_payment_due=claude_result.get("has_payment_due", False),
            document_type=claude_result.get("document_type", ""),
            urgency=claude_result.get("urgency", "LOW"),
            sender=claude_result.get("sender", ""),
            action_required=claude_result.get("action_required", ""),
            is_invitation=claude_result.get("is_invitation", False),
            venue_address=claude_result.get("venue_address", ""),
            appointment_date=claude_result.get("appointment_date", ""),
            output_language=payload.output_language.value,
        )

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Analysis failed: {e}")
        raise HTTPException(
            status_code=503,
            detail="Analysis failed. Please try again.",
        )


# ─── Deep Analysis — PREMIUM ONLY!! ──────────────────────────────────────────
@router.post("/deep-analysis")
def deep_analysis(payload: DetailedAnalysisRequest):
    """
    Premium only — detailed legal breakdown!!
    Section by section, legal references, rights explained!!
    """

    # Check premium status FIRST!!
    subscription = get_subscription_state(payload.user_id)
    is_premium = bool(subscription["premium"])

    if not is_premium:
        raise HTTPException(
            status_code=403,
            detail="PREMIUM_REQUIRED",
        )

    if not payload.ocr_text or len(payload.ocr_text.strip()) < 20:
        raise HTTPException(
            status_code=400,
            detail="Text too short for deep analysis.",
        )

    try:
        logger.info(f"Deep analysis for user {payload.user_id} — language: {payload.output_language}")

        result = deep_analyze_letter_with_claude(
            ocr_text=payload.ocr_text,
            summary=payload.summary,
            output_language=payload.output_language.value,
        )

        logger.info("Deep analysis complete!!")
        return result

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Deep analysis failed: {e}")
        raise HTTPException(
            status_code=503,
            detail="Deep analysis failed. Please try again.",
        )