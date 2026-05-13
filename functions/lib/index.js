"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.summarizeLetter = void 0;
const v2_1 = require("firebase-functions/v2");
const https_1 = require("firebase-functions/v2/https");
const logger = __importStar(require("firebase-functions/logger"));
const vertexai_1 = require("@google-cloud/vertexai");
const cors_1 = __importDefault(require("cors"));
(0, v2_1.setGlobalOptions)({
    region: "europe-west3",
    maxInstances: 5,
});
const corsHandler = (0, cors_1.default)({ origin: true });
/**
 * Computes priority based on simple keyword heuristics.
 *
 * @param {string} text German letter text.
 * @return {{priority: Priority, reason: string}} Priority and a short reason.
 */
function computePriority(text) {
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
        return { priority: "high", reason: "Severe/legal/deadline language" };
    }
    if (isPersonal) {
        return { priority: "medium", reason: "Personal/family addressed letter" };
    }
    if (isPublic) {
        return { priority: "low", reason: "General/public notice" };
    }
    return { priority: "medium", reason: "Default" };
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
function extractImportantDetails(text) {
    var _a, _b, _c, _d, _e;
    const dateRegex = /\b(\d{1,2}[./-]\d{1,2}[./-]\d{2,4})\b/g;
    const emailRegex = /\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b/g;
    const websiteRegex = /\b(?:https?:\/\/|www\.)[^\s]+/g;
    const phoneRegex = /(\+?\d{1,3}[-.\s]?)?(\(?\d{2,5}\)?[-.\s]?)?\d{3,5}[-.\s]?\d{3,5}/g;
    const amountRegex = /\b\d{1,6}(?:[.,]\d{2})?\s?(?:€|eur)\b/gi;
    const uniq = (arr) => Array.from(new Set(arr));
    return {
        dates: uniq((_a = text.match(dateRegex)) !== null && _a !== void 0 ? _a : []),
        emails: uniq((_b = text.match(emailRegex)) !== null && _b !== void 0 ? _b : []),
        websites: uniq((_c = text.match(websiteRegex)) !== null && _c !== void 0 ? _c : []),
        phones: uniq((_d = text.match(phoneRegex)) !== null && _d !== void 0 ? _d : []).slice(0, 10),
        amounts: uniq((_e = text.match(amountRegex)) !== null && _e !== void 0 ? _e : []),
    };
}
exports.summarizeLetter = (0, https_1.onRequest)({ timeoutSeconds: 30, maxInstances: 5 }, async (req, res) => {
    corsHandler(req, res, async () => {
        var _a, _b, _c, _d, _e, _f;
        try {
            if (req.method !== "POST") {
                res.status(405).json({ error: "Use POST" });
                return;
            }
            const text = ((_b = (_a = req.body) === null || _a === void 0 ? void 0 : _a.text) !== null && _b !== void 0 ? _b : "").toString().trim();
            if (!text) {
                res.status(400).json({ error: "Missing 'text' in request body" });
                return;
            }
            const { priority, reason } = computePriority(text);
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
            const vertexAI = new vertexai_1.VertexAI({
                project: process.env.GCLOUD_PROJECT,
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
                contents: [{ role: "user", parts: [{ text: prompt }] }],
            });
            const parts = (_f = (_e = (_d = (_c = result.response.candidates) === null || _c === void 0 ? void 0 : _c[0]) === null || _d === void 0 ? void 0 : _d.content) === null || _e === void 0 ? void 0 : _e.parts) !== null && _f !== void 0 ? _f : [];
            const summaryEn = parts
                .map((p) => { var _a; return ("text" in p ? ((_a = p.text) !== null && _a !== void 0 ? _a : "") : ""); })
                .join("")
                .trim();
            if (!summaryEn) {
                res.status(500).json({ error: "Model returned empty response" });
                return;
            }
            res.status(200).json({
                summary_en: summaryEn,
                priority,
                priority_reason: reason,
                important_details: important,
            });
        }
        catch (e) {
            logger.error("summarizeLetter failed", e);
            res.status(500).json({ error: "Failed to summarize letter" });
        }
    });
});
//# sourceMappingURL=index.js.map