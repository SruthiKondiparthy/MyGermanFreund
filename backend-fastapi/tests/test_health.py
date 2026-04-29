from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)


def test_health() -> None:
    response = client.get('/health')
    assert response.status_code == 200
    assert response.json() == {'status': 'ok'}


def test_summary_for_free_user_is_forbidden() -> None:
    response = client.post('/api/scanner/summary/demo-user', json={'text': 'Important letter text.'})
    assert response.status_code == 403


def test_analyze_extracts_important_fields() -> None:
    response = client.post(
        '/api/scanner/analyze',
        json={
            'user_id': 'demo-user',
            'ocr_text': 'Aktenzeichen AZ-4471. Bitte zahlen Sie 245,50 EUR bis 30.06.2026. Kontakt: service@example.de',
        },
    )
    assert response.status_code == 200
    payload = response.json()
    assert '30.06.2026' in payload['due_dates']
    assert any('EUR' in item for item in payload['amounts'])
    assert 'service@example.de' in payload['contact_info']
