from fastapi.testclient import TestClient
from src.main import app, get_runtime_db
from src.crud.wrapper import get_memory_db

def get_test_db():
    return get_memory_db()

# Override della dipendenza FastAPI per usare un DB in memoria
app.dependency_overrides[get_runtime_db] = get_test_db
client = TestClient(app)

def test_buy_endpoint_creates_asset_and_transaction():
    response = client.post("/buy", json={
        "user_id": "alessio",
        "asset": "ETF",
        "amount": 100,
        "price": 25.5
    })
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "buy recorded"
    assert data["tx"]["asset"] == "ETF"