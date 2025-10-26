from fastapi.testclient import TestClient
from src.main import app, get_runtime_db
from src.crud.wrapper import get_memory_db

# ✅ DB condiviso per tutte le request di questo file
shared_db = get_memory_db()

def get_test_db():
    return shared_db

app.dependency_overrides[get_runtime_db] = get_test_db
client = TestClient(app)

def test_sell_endpoint_reduces_amount():
    client.post("/buy", json={
        "user_id": "alessio",
        "asset": "ETF",
        "amount": 100,
        "price": 25.5
    })

    response = client.post("/sell", json={
        "user_id": "alessio",
        "asset": "ETF",
        "amount": 40,
        "price": 30.0
    })
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "sell recorded"
    assert data["tx"]["amount"] == 40