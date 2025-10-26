from src.crud.wrapper import save, find, update, delete_by_field

def test_save_and_find(fresh_db):
    db = fresh_db
    save("assets", {"asset": "ETF", "amount": 100}, db=db)
    results = find("assets", "asset", "ETF", db=db)
    assert len(results) == 1
    assert results[0]["amount"] == 100

def test_update(fresh_db):
    db = fresh_db
    save("assets", {"asset": "ETF", "amount": 100}, db=db)
    update("assets", "asset", "ETF", {"amount": 150}, db=db)
    results = find("assets", "asset", "ETF", db=db)
    assert results[0]["amount"] == 150

def test_delete_by_field(fresh_db):
    db = fresh_db
    save("assets", {"asset": "ETF", "amount": 100}, db=db)
    delete_by_field("assets", "asset", "ETF", db=db)
    results = find("assets", "asset", "ETF", db=db)
    assert len(results) == 0