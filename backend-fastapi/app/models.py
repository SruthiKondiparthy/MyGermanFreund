from pydantic import BaseModel


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
