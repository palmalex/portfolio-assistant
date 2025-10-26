from crud.wrapper import save, find, update
from datetime import datetime, timezone
from tinydb import TinyDB

def sell_asset(data: dict, db: TinyDB) -> dict:
    """
    Records a sale of an asset.

    Args:
        data (dict): Dictionary with keys 'user_id', 'asset', 'amount', 'price' (optional), 'timestamp' (optional).
        db (TinyDB): Instance of the TinyDB database.

    Returns:
        dict: Dictionary with keys 'status' (str) and 'tx' (dict) representing the recorded transaction.

    - If the asset exists and the amount is sufficient → updates the amount
    - If the amount is insufficient → raises ValueError
    """
    existing = find("assets", "asset", data["asset"], db=db)
    if not existing:
        raise ValueError(f"Asset {data['asset']} non trovato")

    current = existing[0]
    if current["amount"] < data["amount"]:
        raise ValueError(f"Quantità insufficiente per vendere {data['amount']} di {data['asset']}")

    new_amount = current["amount"] - data["amount"]
    update("assets", "asset", data["asset"], {"amount": new_amount}, db=db)

    tx = {
        "type": "sell",
        "user_id": data["user_id"],
        "asset": data["asset"],
        "amount": data["amount"],
        "price": data.get("price", 0),
        "timestamp": data.get("timestamp", datetime.now(timezone.utc).isoformat())
    }

    save("transactions", tx, db=db)

    return {"status": "sell recorded", "tx": tx}