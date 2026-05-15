from pydantic import BaseModel, Field
from typing import Optional
from enum import Enum


class OutputLanguage(str, Enum):
    ENGLISH = "english"
    SIMPLE_GERMAN = "simple_german"


class DetailedAnalysisRequest(BaseModel):
    user_id: str
    ocr_text: str
    summary: str
    output_language: OutputLanguage = OutputLanguage.ENGLISH


class LetterAnalysisRequest(BaseModel):
    user_id: str = Field(..., min_length=1, max_length=128)
    ocr_text: str = Field(..., min_length=20, max_length=10000)
    output_language: OutputLanguage = OutputLanguage.ENGLISH


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
    is_invitation: Optional[bool] = False
    venue_address: Optional[str] = None
    appointment_date: Optional[str] = None
    output_language: Optional[str] = "english"


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