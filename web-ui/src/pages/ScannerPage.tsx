import { useState } from 'react';
import { Link } from 'react-router-dom';

type AnalysisResponse = {
  translated_text: string;
  summary: string;
  due_dates: string[];
  amounts: string[];
  contact_info: string[];
  reference_numbers: string[];
};

const demoText =
  'Aktenzeichen AZ-4471. Bitte zahlen Sie 245,50 EUR bis 30.06.2026. Bei Fragen schreiben Sie an service@example.de oder rufen +49 30 12345678 an.';

export const ScannerPage = () => {
  const [ocrText, setOcrText] = useState(demoText);
  const [result, setResult] = useState<AnalysisResponse | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const analyze = async () => {
    setLoading(true);
    setError('');
    try {
      const response = await fetch('/api/scanner/analyze', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ user_id: 'demo-user', ocr_text: ocrText }),
      });

      if (!response.ok) throw new Error(`Request failed: ${response.status}`);
      const data = (await response.json()) as AnalysisResponse;
      setResult(data);
    } catch (e) {
      setError('Could not analyze letter. Ensure FastAPI backend is running and proxied.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="placeholder-page">
      <h2>Smart Letter Scanner</h2>
      <p>
        Upload/capture German official letters, translate to English, and extract important details (due dates,
        amounts, contacts, references).
      </p>

      <label>
        Upload letter image (OCR implementation hook)
        <input type="file" accept="image/*" />
      </label>

      <label>
        OCR Text
        <textarea rows={8} value={ocrText} onChange={(e) => setOcrText(e.target.value)} />
      </label>

      <div style={{ marginTop: 12, display: 'flex', gap: 8 }}>
        <button className="btn solid" onClick={analyze} disabled={loading}>
          {loading ? 'Analyzing...' : 'Analyze Letter'}
        </button>
        <Link to="/" className="btn soft">
          Back
        </Link>
      </div>

      {error && <p style={{ color: '#b91c1c' }}>{error}</p>}

      {result && (
        <section style={{ marginTop: 16 }}>
          <h3>English Summary</h3>
          <p>{result.summary}</p>
          <h4>Translated Text</h4>
          <p>{result.translated_text}</p>
          <h4>Extracted Important Info</h4>
          <ul>
            <li>Due dates: {result.due_dates.join(', ') || 'None found'}</li>
            <li>Amounts: {result.amounts.join(', ') || 'None found'}</li>
            <li>Contact info: {result.contact_info.join(', ') || 'None found'}</li>
            <li>Reference numbers: {result.reference_numbers.join(', ') || 'None found'}</li>
          </ul>
        </section>
      )}
    </div>
  );
};
