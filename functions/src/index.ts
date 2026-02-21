import * as functions from "firebase-functions";
import * as cors from "cors";

const corsHandler = cors({ origin: true });

/**
 * geminiProxy — Sunucu taraflı Gemini API proxy'si.
 * Flutter Web'de CORS hatalarını önlemek için tüm Gemini istekleri
 * bu Cloud Function üzerinden yapılır.
 *
 * Ortam değişkeni: GEMINI_API_KEY
 * Ayarlamak için: firebase functions:config:set gemini.apikey="YOUR_KEY"
 * veya: firebase functions:secrets:set GEMINI_API_KEY
 *
 * İstek: POST { prompt: string }
 * Yanıt: { text: string } veya { error: string }
 */
export const geminiProxy = functions.https.onRequest((req, res) => {
  corsHandler(req, res, async () => {
    if (req.method === "OPTIONS") {
      res.status(204).send("");
      return;
    }
    if (req.method !== "POST") {
      res.status(405).json({ error: "Method not allowed" });
      return;
    }

    const body = (req.body ?? {}) as { prompt?: unknown };
    const prompt = body.prompt;
    if (!prompt || typeof prompt !== "string" || prompt.trim().length === 0) {
      res.status(400).json({ error: "Missing or invalid prompt" });
      return;
    }

    // API key önce env (firebase functions:secrets:set GEMINI_API_KEY),
    // sonra functions.config().gemini.apikey üzerinden okunur.
    const apiKey: string =
      process.env.GEMINI_API_KEY ??
      (functions.config().gemini?.apikey as string | undefined) ??
      "";

    if (!apiKey) {
      res
        .status(500)
        .json({ error: "Gemini API key not configured on server" });
      return;
    }

    try {
      const url = `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent?key=${apiKey}`;
      const response = await fetch(url, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          contents: [{ parts: [{ text: prompt.trim() }] }],
          generationConfig: { maxOutputTokens: 1024, temperature: 0.7 },
        }),
      });

      if (!response.ok) {
        const errText = await response.text();
        res.status(response.status).json({ error: errText });
        return;
      }

      const data = (await response.json()) as {
        candidates?: Array<{
          content?: { parts?: Array<{ text?: string }> };
        }>;
      };
      const text =
        data?.candidates?.[0]?.content?.parts?.[0]?.text?.trim() ?? "";
      res.status(200).json({ text });
    } catch (err: unknown) {
      const msg = err instanceof Error ? err.message : String(err);
      res.status(500).json({ error: msg });
    }
  });
});
