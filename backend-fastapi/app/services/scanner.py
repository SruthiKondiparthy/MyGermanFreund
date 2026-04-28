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
