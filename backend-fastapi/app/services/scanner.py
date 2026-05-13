import re
import os
import anthropic
import json
from dotenv import load_dotenv

load_dotenv()

# Initialize Claude client
client = anthropic.Anthropic(api_key=os.getenv("ANTHROPIC_API_KEY"))

def analyze_letter_with_claude(ocr_text: str) -> dict:
    """
    Send OCR text to Claude API for intelligent analysis.
    Returns structured extraction of letter details.
    """
    try:
            prompt = f"""You are an expert assistant helping expats in Germany understand
            official German letters and documents.

            Analyze the following German text and extract key information.
            Respond ONLY with a valid JSON object, no markdown, no explanation.

            German text:
            {ocr_text}

            Return this exact JSON structure:
            {{
                "is_german_document": true or false,
                "sender": "Organisation or person who sent this letter",
                "document_type": "e.g. Tax Notice, Health Insurance, Registration, Fine, Invoice etc",
                "letter_date": "Date the letter was written — in original format found in letter",
                "subject": "Subject line or heading appearing above the salutation — translate to English",
                "summary": "2-3 sentence plain English summary of what this letter is about",
                "action_required": "Specific action the recipient needs to take — be concise",
                "urgency": "HIGH or MEDIUM or LOW",
                "due_dates": ["list of deadline dates found"],
                "has_payment_due": true or false,
                "amounts": ["list of amounts that must be paid — only include if has_payment_due is true"],
                "contact_info": ["list of emails and phone numbers found"],
                "reference_numbers": ["list of reference, case, or customer numbers found"]
            }}"""

            message = client.messages.create(
                model="claude-sonnet-4-5",
                max_tokens=1024,
                messages=[
                    {"role": "user", "content": prompt}
                ]
            )

            response_text = message.content[0].text
            clean = response_text.replace("```json", "").replace("```", "").strip()
            result = json.loads(clean)
            return result

    except Exception as e:
        print(f"CLAUDE ERROR: {type(e).__name__}: {str(e)}")
        raise


def translate_text(text: str, source_lang: str, target_lang: str) -> str:
    """Keep for backward compatibility — now powered by Claude"""
    try:
        result = analyze_letter_with_claude(text)
        return result.get("translated_text", text)
    except Exception:
        return f"[{source_lang}->{target_lang}] {text}"


def summarize_text(text: str) -> str:
    """Keep for backward compatibility — now powered by Claude"""
    try:
        result = analyze_letter_with_claude(text)
        return result.get("summary", text[:240])
    except Exception:
        first_segment = text.strip().split(".")[0]
        return first_segment[:240] if first_segment else "No summary available"


def get_monthly_scan_usage(user_id: str) -> int:
    mock_usage = {
        "demo-user": 2,
        "demo-premium-user": 14,
    }
    return mock_usage.get(user_id, 0)


def extract_due_dates(text: str) -> list[str]:
    pattern = r"\b(?:\d{1,2}[./-]\d{1,2}[./-]\d{2,4}|\d{4}-\d{2}-\d{2})\b"
    return sorted(set(re.findall(pattern, text)))


def extract_amounts(text: str) -> list[str]:
    pattern = r"\b\d{1,3}(?:[.,]\d{3})*(?:[.,]\d{2})?\s?(?:€|EUR)\b"
    return sorted(set(re.findall(pattern, text, flags=re.IGNORECASE)))


def extract_contact_info(text: str) -> list[str]:
    emails = re.findall(r"[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+", text)
    phones = re.findall(r"\+?\d[\d\s\-/()]{7,}\d", text)
    return sorted(set(emails + phones))


def extract_reference_numbers(text: str) -> list[str]:
    pattern = r"\b(?:Aktenzeichen|Vorgangsnummer|Referenz|Ref\.?|Kundennummer)[:\s-]*([A-Z0-9-]{4,})\b"
    return sorted(set(match.strip() for match in re.findall(pattern, text, flags=re.IGNORECASE)))