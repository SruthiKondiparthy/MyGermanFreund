import re
import os
import json
import time
import logging
import anthropic
from dotenv import load_dotenv

load_dotenv()

logger = logging.getLogger("mygermanfreund.scanner")

# ─── Client ─────────────────────────────────────────────────────────────────
client = anthropic.Anthropic(api_key=os.getenv("ANTHROPIC_API_KEY"))

# ─── Models ─────────────────────────────────────────────────────────────────
HAIKU_MODEL = "claude-haiku-4-5"      # Cheap — validation only!!
SONNET_MODEL = "claude-sonnet-4-5"    # Full analysis!!

# ─── System Prompt — Cached!! ───────────────────────────────────────────────
SYSTEM_PROMPT = """You are an expert assistant helping expats in Germany
understand official German letters and documents.

You have deep knowledge of:
- German bureaucratic language (Behördendeutsch)
- Finanzamt (tax office) letters
- Health insurance (Krankenkasse) correspondence
- Registration letters (Anmeldung/Ummeldung)
- Court and legal notices
- Utility and landlord letters
- Bank and financial correspondence
- Government benefit letters

Always respond in valid JSON only. No markdown. No explanation outside JSON."""

# ─── Language Instructions ───────────────────────────────────────────────────
LANGUAGE_INSTRUCTIONS = {
    "english": """
Respond in ENGLISH throughout.
Use simple, clear English that non-native speakers can understand.
Avoid complex vocabulary where possible.
""",
    "simple_german": """
Antworte auf EINFACHEM DEUTSCH (Leichte Sprache).
Verwende:
- Kurze Sätze (max 10 Wörter)
- Einfache, alltägliche Wörter
- Keine Fachbegriffe ohne Erklärung
- Aktive Sprache statt Passiv
- Konkrete statt abstrakte Begriffe

Beispiel gute Erklärung:
NICHT: "Der Adressat wird aufgefordert, den ausstehenden Betrag zu begleichen"
SONDERN: "Sie müssen Geld bezahlen. Der Betrag ist 450 Euro."
"""
}

# ─── Step 1: Haiku Validation — CHEAP!! ─────────────────────────────────────
def validate_is_german_document(ocr_text: str) -> dict:
    """Haiku validation — cheap!! Language agnostic!!"""
    logger.info("Haiku validation starting")
    try:
        message = client.messages.create(
            model=HAIKU_MODEL,
            max_tokens=100,
            system="You are a document validator. Respond only with valid JSON.",
            messages=[{
                "role": "user",
                "content": f"""Is this text from a German official letter,
document, email, invoice, or any formal German text?

Text sample:
{ocr_text[:500]}

Respond ONLY with this JSON:
{{
    "is_valid": true or false,
    "reason": "one sentence explanation"
}}"""
            }]
        )
        response = message.content[0].text
        clean = response.replace("```json", "").replace("```", "").strip()
        result = json.loads(clean)
        logger.info(f"Haiku result: {result}")
        return result
    except Exception as e:
        logger.warning(f"Haiku validation failed: {e} — defaulting valid")
        return {"is_valid": True, "reason": "Validation skipped"}


# ─── Step 2: Sonnet Full Analysis — With Prompt Caching!! ───────────────────
def analyze_letter_with_claude(
        ocr_text: str,
        output_language: str = "english",
        max_retries: int = 2
) -> dict:
    """
    Full analysis with language selection and prompt caching!!
    output_language: 'english' or 'simple_german'
    """
    logger.info(f"Sonnet analysis — language: {output_language}")

    lang_instruction = LANGUAGE_INSTRUCTIONS.get(
        output_language,
        LANGUAGE_INSTRUCTIONS["english"]
    )

    prompt = f"""Analyze the following German text and extract key information.
The text may contain multiple pages separated by "--- Page X ---" markers.
Treat it as ONE complete document.

{lang_instruction}

Respond ONLY with a valid JSON object, no markdown, no explanation.

German text:
{ocr_text}

Return this exact JSON structure:
{{
    "is_german_document": true or false,
    "sender": "Organisation or person who sent this letter",
    "document_type": "Type of document — in chosen language",
    "letter_date": "Date the letter was written",
    "subject": "Subject line — translated to chosen language",
    "summary": "2-3 sentence summary — in chosen language!!",
    "action_required": "What recipient needs to do — in chosen language!!",
    "urgency": "HIGH or MEDIUM or LOW",
    "due_dates": ["deadline dates only"],
    "has_payment_due": true or false,
    "amounts": ["amounts that must be paid"],
    "contact_info": ["emails and phone numbers"],
    "reference_numbers": ["reference numbers"],
    "is_invitation": true or false,
    "venue_address": "physical address if mentioned",
    "appointment_date": "appointment date and time if mentioned"
}}"""

    last_error = None

    for attempt in range(max_retries + 1):
        try:
            logger.info(f"Sonnet attempt {attempt + 1}")
            start_time = time.time()

            message = client.messages.create(
                model=SONNET_MODEL,
                max_tokens=1024,
                system=[{
                    "type": "text",
                    "text": SYSTEM_PROMPT,
                    "cache_control": {"type": "ephemeral"}
                }],
                messages=[
                    {"role": "user", "content": prompt}
                ]
            )

            elapsed = time.time() - start_time
            logger.info(f"Sonnet responded in {elapsed:.2f}s")

            # Log cache usage!!
            usage = message.usage
            logger.info(
                f"Tokens — Input: {usage.input_tokens}, "
                f"Output: {usage.output_tokens}, "
                f"Cache created: {getattr(usage, 'cache_creation_input_tokens', 0)}, "
                f"Cache read: {getattr(usage, 'cache_read_input_tokens', 0)}"
            )

            response_text = message.content[0].text
            clean = response_text.replace("```json", "").replace("```", "").strip()

            try:
                result = json.loads(clean)
            except json.JSONDecodeError as e:
                logger.error(f"JSON parse failed: {e}")
                raise ValueError("Invalid response from AI service")

            validated = validate_claude_response(result)
            logger.info("Analysis complete!!")
            return validated

        except anthropic.RateLimitError:
            raise Exception("Service busy. Please try again.")
        except anthropic.APITimeoutError as e:
            last_error = e
            if attempt < max_retries:
                time.sleep(1)
                continue
        except anthropic.APIError as e:
            last_error = e
            if attempt < max_retries:
                time.sleep(1)
                continue
        except ValueError as e:
            raise Exception(str(e))
        except Exception as e:
            last_error = e
            if attempt < max_retries:
                time.sleep(1)
                continue

    raise Exception("Analysis service unavailable. Please try again.")


# ─── Step 3: Deep Analysis — PREMIUM ONLY!! ──────────────────────────────────
def deep_analyze_letter_with_claude(
        ocr_text: str,
        summary: str,
        output_language: str = "english",
        max_retries: int = 2
) -> dict:
    """
    Premium deep analysis — section by section breakdown!!
    Legal references explained in plain language!!
    output_language: 'english' or 'simple_german'
    """
    logger.info(f"Deep analysis starting — language: {output_language}")

    lang_instruction = LANGUAGE_INSTRUCTIONS.get(
        output_language,
        LANGUAGE_INSTRUCTIONS["english"]
    )

    prompt = f"""You are a legal and bureaucratic expert helping expats
understand German official letters in depth.

{lang_instruction}

Original letter text:
{ocr_text}

Basic summary already provided: {summary}

Now provide a DETAILED analysis. Respond ONLY with valid JSON:
{{
    "section_breakdown": [
        {{
            "section": "Section name",
            "plain_explanation": "What this part means in simple terms"
        }}
    ],
    "legal_references": [
        {{
            "reference": "§ 149 AO or similar",
            "plain_meaning": "What this law means for the reader"
        }}
    ],
    "your_rights": [
        "Right 1 explained simply",
        "Right 2 explained simply"
    ],
    "consequences_if_ignored": "What happens if no action is taken",
    "recommended_next_steps": [
        "Step 1 — specific and actionable",
        "Step 2 — specific and actionable",
        "Step 3 — specific and actionable"
    ],
    "helpful_phrases": [
        {{
            "german": "Ich möchte Widerspruch einlegen",
            "english": "I would like to file an appeal"
        }}
    ]
}}"""

    last_error = None

    for attempt in range(max_retries + 1):
        try:
            logger.info(f"Deep analysis attempt {attempt + 1}")
            start_time = time.time()

            message = client.messages.create(
                model=SONNET_MODEL,
                max_tokens=2048,  # Larger — more detailed response!!
                system=[{
                    "type": "text",
                    "text": SYSTEM_PROMPT,
                    "cache_control": {"type": "ephemeral"}  # Cached!!
                }],
                messages=[
                    {"role": "user", "content": prompt}
                ]
            )

            elapsed = time.time() - start_time
            logger.info(f"Deep analysis responded in {elapsed:.2f}s")

            usage = message.usage
            logger.info(
                f"Deep analysis tokens — "
                f"Input: {usage.input_tokens}, "
                f"Output: {usage.output_tokens}, "
                f"Cache read: {getattr(usage, 'cache_read_input_tokens', 0)}"
            )

            response_text = message.content[0].text
            clean = response_text.replace("```json", "").replace("```", "").strip()

            try:
                result = json.loads(clean)
            except json.JSONDecodeError as e:
                logger.error(f"Deep analysis JSON parse failed: {e}")
                raise ValueError("Invalid response from AI service")

            logger.info("Deep analysis complete!!")
            return result

        except anthropic.RateLimitError:
            raise Exception("Service busy. Please try again.")
        except anthropic.APITimeoutError as e:
            last_error = e
            if attempt < max_retries:
                time.sleep(2)  # Longer wait for deep analysis!!
                continue
        except anthropic.APIError as e:
            last_error = e
            if attempt < max_retries:
                time.sleep(2)
                continue
        except ValueError as e:
            raise Exception(str(e))
        except Exception as e:
            last_error = e
            if attempt < max_retries:
                time.sleep(2)
                continue

    raise Exception("Deep analysis unavailable. Please try again.")


# ─── Response Validation ─────────────────────────────────────────────────────
def validate_claude_response(response: dict) -> dict:
    """Validates and sanitizes Claude response — ensures all fields exist!!"""
    return {
        "is_german_document": bool(response.get("is_german_document", True)),
        "sender": str(response.get("sender", "")),
        "document_type": str(response.get("document_type", "")),
        "letter_date": str(response.get("letter_date", "")),
        "subject": str(response.get("subject", "")),
        "translated_text": str(response.get("translated_text", "")),
        "summary": str(response.get("summary", "Summary unavailable")),
        "action_required": str(response.get("action_required", "")),
        "urgency": _validate_urgency(response.get("urgency")),
        "due_dates": _validate_list(response.get("due_dates")),
        "has_payment_due": bool(response.get("has_payment_due", False)),
        "amounts": _validate_list(response.get("amounts")),
        "contact_info": _validate_list(response.get("contact_info")),
        "reference_numbers": _validate_list(response.get("reference_numbers")),
        "is_invitation": bool(response.get("is_invitation", False)),
        "venue_address": str(response.get("venue_address", "")),
        "appointment_date": str(response.get("appointment_date", "")),
    }


def _validate_urgency(urgency) -> str:
    valid = ["HIGH", "MEDIUM", "LOW"]
    if isinstance(urgency, str) and urgency.upper() in valid:
        return urgency.upper()
    return "LOW"


def _validate_list(value) -> list[str]:
    if not isinstance(value, list):
        return []
    return [str(item) for item in value if item]


# ─── Backward Compatible Functions ───────────────────────────────────────────
def get_monthly_scan_usage(user_id: str) -> int:
    mock_usage = {
        "demo-user": 0,
        "demo-premium-user": 14,
    }
    return mock_usage.get(user_id, 0)


def increment_scan_usage(user_id: str) -> int:
    """Increment scan count — connect to Firebase in production!!"""
    logger.info(f"Scan usage incremented for user: {user_id}")
    return 1


def translate_text(text: str, source_lang: str, target_lang: str) -> str:
    return f"[{source_lang}->{target_lang}] {text}"


def summarize_text(text: str) -> str:
    first_segment = text.strip().split(".")[0]
    return first_segment[:240] if first_segment else "No summary available"


def extract_due_dates(text: str) -> list[str]:
    pattern = r"\b(?:\d{1,2}[./-]\d{1,2}[./-]\d{2,4}|\d{4}-\d{2}-\d{2})\b"
    return sorted(set(re.findall(pattern, text)))


def extract_amounts(text: str) -> list[str]:
    pattern = r"\b\d{1,3}(?:[.,]\d{3})*(?:[.,]\d{2})?\s?(?:€|EUR)\b"
    return sorted(set(re.findall(pattern, text, flags=re.IGNORECASE)))


def extract_contact_info(text: str) -> list[str]:
    emails = re.findall(
        r"[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+", text
    )
    phones = re.findall(r"\+?\d[\d\s\-/()]{7,}\d", text)
    return sorted(set(emails + phones))


def extract_reference_numbers(text: str) -> list[str]:
    pattern = (
        r"\b(?:Aktenzeichen|Vorgangsnummer|Referenz|Ref\.?|Kundennummer)"
        r"[:\s-]*([A-Z0-9-]{4,})\b"
    )
    return sorted(set(
        match.strip()
        for match in re.findall(pattern, text, flags=re.IGNORECASE)
    ))