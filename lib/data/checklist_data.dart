final Map<String, dynamic> checklistData = {
  // 🏠 Anmeldung (Address Registration)
  "anmeldung": {
    "title": "🏠 Anmeldung (Address Registration)",
    "description":
    "Mandatory for everyone living in Germany — including those relocating within Germany. "
        "This process officially registers your home address with the local Bürgeramt.",
    "steps": [
      {
        "text": "Fill in the registration form (Anmeldeformular)",
        "searchQuery": "Anmeldeformular Bürgeramt",
        "searchHint": "e.g. Berlin or 10115",
      },
      {
        "text": "Bring your passport & rental contract",
      },
      {
        "text": "Book an appointment at Bürgeramt",
        "searchQuery": "Bürgeramt Termin buchen",
        "searchHint": "e.g. Munich or 80331",
      },
      {
        "text": "Submit documents and receive Meldebescheinigung",
      },
      {
        "text":
        "Keep the Meldebescheinigung safe — required for banks, tax ID, health insurance, etc.",
      },
    ],
    "documents": [
      {
        "title": "Completed registration form (Anmeldeformular)",
        "isSampleForm": true,
        "samplePath": "assets/forms/anmeldung_sample.pdf",
      },
      {"title": "Passport or ID card"},
      {"title": "Rental confirmation (Wohnungsgeberbestätigung)"},
      {"title": "Visa or residence permit (if applicable)"},
    ],
    "usefulLinks": [
      {
        "title": "General info on Anmeldung (Berlin.de)",
        "url": "https://service.berlin.de/dienstleistung/120686/"
      },
      {
        "title": "Official Germany Portal (Deutschland.de)",
        "url":
        "https://www.deutschland.de/en/topic/life/anmeldung-registration-in-germany"
      },
    ],
    "vocabulary": [
      "Vocabulary related to Anmeldung"
    ],
  },

  // 🏦 Bank Account Opening
  "bank": {
    "title": "🏦 Open a Bank Account",
    "description":
    "Opening a German bank account (Girokonto) is essential for salary, rent, and daily expenses.",
    "steps": [
      {"text": "Choose a bank (online or local branch)"},
      {"text": "Bring your passport & Meldebescheinigung"},
      {"text": "Fill in the bank account opening form"},
      {"text": "Receive IBAN and debit card"},
    ],
    "documents": [
      {"title": "Passport or ID card"},
      {"title": "Proof of address (Meldebescheinigung)"},
      {"title": "Employment or student proof (if required)"},
    ],
    "usefulLinks": [
      {
        "title": "Compare German banks (Check24)",
        "url": "https://www.check24.de/girokonto/"
      },
    ],
    "vocabulary": [
      "Vocabulary related to Bank account opening"
    ],
  },

  // 🏥 Health Insurance Registration
  "insurance": {
    "title": "🏥 Health Insurance Registration",
    "description":
    "Health insurance is mandatory in Germany for everyone working or studying. "
        "You can choose between public (gesetzlich) or private (privat) insurance.",
    "steps": [
      {
        "text": "Compare providers (AOK, TK, Barmer, etc.)",
        "searchQuery": "compare German health insurance providers",
        "searchHint": "e.g. AOK, TK, Barmer"
      },
      {
        "text": "Fill application online or visit local branch",
      },
      {
        "text":
        "Submit passport, Meldebescheinigung, and employment/student proof",
      },
      {"text": "Receive your insurance card"},
    ],
    "documents": [
      {"title": "Passport or ID"},
      {"title": "Proof of address (Meldebescheinigung)"},
      {"title": "University enrollment or work contract"},
    ],
    "usefulLinks": [
      {"title": "AOK Official Site", "url": "https://www.aok.de/pk/"},
      {"title": "Techniker Krankenkasse (TK)", "url": "https://www.tk.de/"},
    ],
    "vocabulary": [
      "Vocabulary related to Health Insurance"
    ],
  },

  // 🧾 Tax ID Application
  "taxid": {
    "title": "🧾 Apply for Tax ID (Steueridentifikationsnummer)",
    "description":
    "Once you’ve registered your address (Anmeldung), your Tax ID is automatically generated "
        "and sent by post within 2–4 weeks. If not received, you can request it manually.",
    "steps": [
      {"text": "Wait 2–4 weeks after Anmeldung for your Tax ID letter"},
      {
        "text": "If not received, request Tax ID at your local Finanzamt",
        "searchQuery": "Finanzamt Tax ID request",
        "searchHint": "e.g. Frankfurt Finanzamt"
      },
      {"text": "Provide your Meldebescheinigung and passport"},
      {"text": "Keep the Tax ID safe for job, bank, and tax purposes"},
    ],
    "documents": [
      {"title": "Passport or ID"},
      {"title": "Proof of address (Meldebescheinigung)"},
    ],
    "usefulLinks": [
      {
        "title": "Request Tax ID (Bundeszentralamt für Steuern)",
        "url":
        "https://www.bzst.de/DE/Privatpersonen/IdNr/ID_Erstanmeldung/id_erstanmeldung_node.html"
      }
    ],
    "vocabulary": [
      "Vocabulary related to Tax ID"
    ],
  },

  // 🪪 Residence Permit
  "residence": {
    "title": "🪪 Apply for Residence Permit (Aufenthaltstitel)",
    "description":
    "Non-EU citizens staying longer than 90 days must apply for a residence permit "
        "at their local Ausländerbehörde (Foreigners’ Office).",
    "steps": [
      {
        "text": "Book an appointment at Ausländerbehörde",
        "searchQuery": "Ausländerbehörde appointment booking",
        "searchHint": "e.g. Stuttgart or 70173",
      },
      {
        "text": "Prepare required documents (passport, proof of income, etc.)",
      },
      {"text": "Attend appointment and provide biometric photo"},
      {"text": "Receive residence permit card (takes 4–6 weeks)"},
    ],
    "documents": [
      {"title": "Passport"},
      {"title": "Proof of address (Meldebescheinigung)"},
      {"title": "Biometric photo"},
      {"title": "Proof of income or enrollment"},
      {"title": "Health insurance confirmation"},
    ],
    "usefulLinks": [
      {
        "title": "Federal Office for Migration and Refugees (BAMF)",
        "url": "https://www.bamf.de/EN/Themen/MigrationAufenthalt/migrationaufenthalt-node.html"
      }
    ],
    "vocabulary": [
      "Vocabulary related to Residence Permit"
    ],
  },
};
