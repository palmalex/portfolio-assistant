from crud.wrapper import save, find, update
from datetime import datetime, timezone
from tinydb import TinyDB

def buy_asset(data: dict, db: TinyDB) -> dict:
    tx = {
        "type": "buy",
        "user_id": data["user_id"],
        "asset": data["asset"],
        "amount": data["amount"],
        "price": data.get("price", 0),
        "timestamp": data.get("timestamp", datetime.now(timezone.utc).isoformat())
    }

    save("transactions", tx, db=db)

    existing = find("assets", "asset", data["asset"], db=db)
    if existing:
        current = existing[0]
        new_amount = current["amount"] + data["amount"]
        update("assets", "asset", data["asset"], {"amount": new_amount}, db=db)
    else:
        save("assets", {"asset": data["asset"], "amount": data["amount"]}, db=db)

    return {"status": "buy recorded", "tx": tx}