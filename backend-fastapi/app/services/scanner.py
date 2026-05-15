import re


def translate_text(text: str, source_lang: str, target_lang: str) -> str:
    return f"[{source_lang}->{target_lang}] {text}"


def summarize_text(text: str) -> str:
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
