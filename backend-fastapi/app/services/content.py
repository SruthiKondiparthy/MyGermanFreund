def get_buzz_payload() -> dict[str, dict[str, str]]:
    return {
        "news": {
            "en": "Berlin expands digital services for city registration.",
            "de": "Berlin erweitert digitale Services für die Anmeldung.",
        },
        "culture_tip": {
            "en": "Quiet hours (Ruhezeiten) are commonly respected in apartment buildings.",
            "de": "Ruhezeiten werden in Mehrfamilienhäusern meist streng beachtet.",
        },
        "phrase_of_the_day": {
            "en": "Do I need an appointment?",
            "de": "Brauche ich einen Termin?",
        },
    }


def get_guides_payload() -> list[dict[str, str | list[str]]]:
    return [
        {
            "id": "anmeldung",
            "title_en": "City Registration (Anmeldung)",
            "title_de": "Wohnsitzanmeldung",
            "steps": [
                "Book appointment at local Bürgeramt",
                "Prepare passport, housing confirmation, registration form",
                "Attend appointment and keep registration certificate",
            ],
        },
        {
            "id": "health_insurance",
            "title_en": "Health Insurance",
            "title_de": "Krankenversicherung",
            "steps": [
                "Choose statutory or private insurance",
                "Submit enrollment documents",
                "Store insurance confirmation for employer/visa",
            ],
        },
        {
            "id": "banking",
            "title_en": "Bank Account Setup",
            "title_de": "Bankkonto eröffnen",
            "steps": [
                "Compare account types and fees",
                "Complete identification process",
                "Activate online banking and card",
            ],
        },
    ]
