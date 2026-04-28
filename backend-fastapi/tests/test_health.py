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
