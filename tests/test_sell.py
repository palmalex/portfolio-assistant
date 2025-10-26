import pytest
from src.services.sell import sell_asset
from src.services.buy import buy_asset
from src.crud.wrapper import find

def test_sell_asset_reduces_amount(fresh_db):
    db = fresh_db

    # Prima compro 100 ETF
    buy_asset({
        "user_id": "alessio",
        "asset": "ETF",
        "amount": 100,
        "price": 25.5
    }, db=db)

    # Poi vendo 40 ETF
    sell_asset({
        "user_id": "alessio",
        "asset": "ETF",
        "amount": 40,
        "price": 30.0
    }, db=db)

    assets = find("assets", "asset", "ETF", db=db)
    assert assets[0]["amount"] == 60

    txs = find("transactions", "asset", "ETF", db=db)
    assert len(txs) == 2  # una buy + una sell
    assert txs[-1]["type"] == "sell"

def test_sell_asset_insufficient_amount(fresh_db):
    db = fresh_db

    # Creo asset con 10 unità
    buy_asset({
        "user_id": "alessio",
        "asset": "ETF",
        "amount": 10,
        "price": 25.5
    }, db=db)

    # Provo a vendere più di quanto possiedo
    with pytest.raises(ValueError):
        sell_asset({
            "user_id": "alessio",
            "asset": "ETF",
            "amount": 20,
            "price": 30.0
        }, db=db)

def test_sell_asset_not_found(fresh_db):
    db = fresh_db

    # Nessun asset registrato
    with pytest.raises(ValueError):
        sell_asset({
            "user_id": "alessio",
            "asset": "ETF",
            "amount": 10,
            "price": 30.0
        }, db=db)