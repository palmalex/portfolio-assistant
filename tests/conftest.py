import sys, os
import pytest
from fastapi.testclient import TestClient

# ✅ Imposta il path PRIMA di importare main
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from src.main import app
from src.crud.wrapper import get_memory_db

@pytest.fixture
def fresh_db():
    """Restituisce un DB TinyDB in memoria, sempre nuovo e vuoto."""
    return get_memory_db()

@pytest.fixture
def client():
    return TestClient(app)