from src.services.buy import buy_asset
from src.crud.wrapper import find

def test_buy_asset_isolated(fresh_db):
    db = fresh_db

    buy_asset({
        "user_id": "alessio",
        "asset": "ETF",
        "amount": 100,
        "price": 25.5
    }, db=db)

    assets = find("assets", "asset", "ETF", db=db)
    assert len(assets) == 1
    assert assets[0]["amount"] == 100

    txs = find("transactions", "asset", "ETF", db=db)
    assert len(txs) == 1
    assert txs[0]["type"] == "buy"