from fastapi import FastAPI, Depends
from services.buy import buy_asset
from services.sell import sell_asset
from services.accounts import create_account, get_account, list_accounts
from crud.wrapper import get_memory_db
from tinydb import TinyDB

app = FastAPI()

def get_runtime_db() -> TinyDB:
    """DB runtime: for simplicity, we use MemoryStorage even at runtime.
       In production, you could replace it with a file or Firestore."""
    return get_memory_db()

@app.post("/buy")
def buy_endpoint(data: dict, db: TinyDB = Depends(get_runtime_db)):
    return buy_asset(data, db=db)

@app.post("/sell")
def sell_endpoint(data: dict, db: TinyDB = Depends(get_runtime_db)):
    return sell_asset(data, db=db)

@app.get("/accounts")
def get_accounts(db: TinyDB = Depends(get_runtime_db)):
    return list_accounts(db=db)

@app.post("/accounts")
def api_create_account(data: dict, db: TinyDB = Depends(get_runtime_db)):
    return create_account(data, db=db)

@app.get("/accounts/{account_id}")
def api_get_account(account_id: str, db: TinyDB = Depends(get_runtime_db)):
    return get_account(account_id, db=db)

