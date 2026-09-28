import requests

def test_health():
    response = requests.get("http://localhost:5001/health")
    assert response.status_code == 200
    assert response.json()["status"] == "broken"

def test_version():
    response = requests.get("http://localhost:5001/version")
    assert response.status_code == 200
