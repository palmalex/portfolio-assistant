from tinydb import TinyDB
from crud.wrapper import find, save
from typing import Dict

VALID_TYPES = {"administered", "non-administered"}

def validate_account_data(payload: Dict) -> None:
    required_fields = {"account_id", "name", "type", "currency_base"}
    missing = [k for k in required_fields if k not in payload]
    if missing:
        raise ValueError(f"Missing required fields: {', '.join(missing)}")
    if payload["type"] not in VALID_TYPES:
        raise ValueError(f"Invalid account type: {payload['type']}")

def create_account(payload: Dict, db: TinyDB) -> Dict:
    validate_account_data(payload)
    existing = find("accounts", "account_id", payload["account_id"], db=db)
    if existing:
        raise ValueError(f"Account with id {payload['account_id']} already exists")
    save("accounts", payload, db=db)
    return {"status": "account created", "account": payload}

def get_account(account_id: str, db: TinyDB) -> Dict:
    rows = find("accounts", "account_id", account_id, db=db)
    if not rows:
        raise ValueError(f"Account with id {account_id} not found")
    return rows[0]

def list_accounts(db: TinyDB) -> list:
    return db.table("accounts").all()
