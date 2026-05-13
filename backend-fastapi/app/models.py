from pydantic import BaseModel
from typing import Optional


class UserContext(BaseModel):
    user_id: str
    premium: bool = False


class TranslationRequest(BaseModel):
    text: str
    source_lang: str = "de"
    target_lang: str = "en"


class TranslationResponse(BaseModel):
    translated_text: str


class SummaryResponse(BaseModel):
    summary: str


class ScanQuotaResponse(BaseModel):
    monthly_limit: int
    used: int
    remaining: int
    premium: bool


class LetterAnalysisRequest(BaseModel):
    user_id: str
    ocr_text: str


class LetterAnalysisResponse(BaseModel):
    original_text: str
    translated_text: str
    summary: str
    due_dates: list[str] = []
    amounts: list[str] = []
    contact_info: list[str] = []
    reference_numbers: list[str] = []
    premium: bool
    subject: Optional[str] = None
    letter_date: Optional[str] = None
    has_payment_due: Optional[bool] = False
    document_type: Optional[str] = None
    urgency: Optional[str] = "LOW"
    sender: Optional[str] = None
    action_required: Optional[str] = None
