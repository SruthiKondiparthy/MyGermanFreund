import {setGlobalOptions} from "firebase-functions/v2";
import {onRequest} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import {VertexAI} from "@google-cloud/vertexai";
import cors, {type CorsOptions} from "cors";

setGlobalOptions({
  region: "europe-west3",
  maxInstances: 5,
});

const corsHandler = cors({origin: true} satisfies CorsOptions);

type Priority = "low" | "medium" | "high";

/**
 * Computes priority based on simple keyword heuristics.
 *
 * @param {string} text German letter text.
 * @return {{priority: Priority, reason: string}} Priority and a short reason.
 */
function computePriority(text: string): {priority: Priority; reason: string} {
  const t = text.toLowerCase();

  const severe = [
    "bußgeld",
    "verwarnung",
    "mahnung",
    "inkasso",
    "gericht",
    "vollstreck",
    "frist",
    "zahlungspflicht",
    "rechts",
    "ordnungsgeld",
  ];

  const personal = [
    "sehr geehrte frau",
    "sehr geehrter herr",
    "familie",
    "herrn",
    "frau",
  ];

  const publicNotice = [
    "sehr geehrte damen und herren",
    "anwohner",
    "anlieger",
    "bewohner",
    "hinweis",
    "information",
  ];

  const hasSevere = severe.some((k) => t.includes(k));
  const isPersonal = personal.some((k) => t.includes(k));
  const isPublic = publicNotice.some((k) => t.includes(k));

  if (isPersonal && hasSevere) {
    return {
      priority: "high",
      reason: "Personal + severe/legal/deadline language",
    };
  }

  if (hasSevere) {
    return {priority: "high", reason: "Severe/legal/deadline language"};
  }

  if (isPersonal) {
    return {priority: "medium", reason: "Personal/family addressed letter"};
  }

  if (isPublic) {
    return {priority: "low", reason: "General/public notice"};
  }

  return {priority: "medium", reason: "Default"};
}

/**
 * Extracts simple structured details (dates, contacts, amounts) via regex.
 *
 * @param {string} text German letter text.
 * @return {{
 *   dates: string[],
 *   emails: string[],
 *   websites: string[],
 *   phones: string[],
 *   amounts: string[]
 * }} Extracted details.
 */
function extractImportantDetails(text: string) {
  const dateRegex = /\b(\d{1,2}[./-]\d{1,2}[./-]\d{2,4})\b/g;
  const emailRegex =
    /\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b/g;
  const websiteRegex = /\b(?:https?:\/\/|www\.)[^\s]+/g;

  const phoneRegex =
    /(\+?\d{1,3}[-.\s]?)?(\(?\d{2,5}\)?[-.\s]?)?\d{3,5}[-.\s]?\d{3,5}/g;

  const amountRegex = /\b\d{1,6}(?:[.,]\d{2})?\s?(?:€|eur)\b/gi;

  const uniq = (arr: string[]) => Array.from(new Set(arr));

  return {
    dates: uniq(text.match(dateRegex) ?? []),
    emails: uniq(text.match(emailRegex) ?? []),
    websites: uniq(text.match(websiteRegex) ?? []),
    phones: uniq(text.match(phoneRegex) ?? []).slice(0, 10),
    amounts: uniq(text.match(amountRegex) ?? []),
  };
}

export const summarizeLetter = onRequest(
  {timeoutSeconds: 30, maxInstances: 5},
  async (req, res) => {
    corsHandler(req, res, async () => {
      try {
        if (req.method !== "POST") {
          res.status(405).json({error: "Use POST"});
          return;
        }

        const text = (req.body?.text ?? "").toString().trim();
        if (!text) {
          res.status(400).json({error: "Missing 'text' in request body"});
          return;
        }

        const {priority, reason} = computePriority(text);
        const important = extractImportantDetails(text);

        const prompt = [
          "You are helping a non-German speaker understand a German letter.",
          "",
          "Write ONE natural English paragraph that implicitly covers 5W1H:",
          "What it is about, why it was sent, when (dates/range),",
          "where (location), who is involved / who to contact,",
          "and how/what the reader should do.",
          "",
          "Do NOT provide a full translation.",
          "Be clear and simple. If no action is required, explicitly say so.",
          "If details are unclear, say so and do not guess.",
          "",
          "German letter text:",
          "\"\"\"",
          text,
          "\"\"\"",
        ].join("\n");

        const vertexAI = new VertexAI({
          project: process.env.GCLOUD_PROJECT!,
          location: "europe-west3",
        });

        const model = vertexAI.getGenerativeModel({
          model: "gemini-1.5-flash",
          generationConfig: {
            maxOutputTokens: 300,
            temperature: 0.2,
          },
        });

        const result = await model.generateContent({
          contents: [{role: "user", parts: [{text: prompt}]}],
        });

        const parts = result.response.candidates?.[0]?.content?.parts ?? [];

        const summaryEn = parts
          .map((p) => ("text" in p ? (p.text ?? "") : ""))
          .join("")
          .trim();

        if (!summaryEn) {
          res.status(500).json({error: "Model returned empty response"});
          return;
        }

        res.status(200).json({
          summary_en: summaryEn,
          priority,
          priority_reason: reason,
          important_details: important,
        });
      } catch (e: unknown) {
        logger.error("summarizeLetter failed", e);
        res.status(500).json({error: "Failed to summarize letter"});
      }
    });
  }
);
