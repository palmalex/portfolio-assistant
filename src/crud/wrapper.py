from tinydb import TinyDB, Query
from tinydb.storages import MemoryStorage

def get_memory_db() -> TinyDB:
    """Returns an in-memory database, always empty."""
    return TinyDB(storage=MemoryStorage)

def save(collection: str, data: dict, db: TinyDB) -> int:
    return db.table(collection).insert(data)

def get_all(collection: str, db: TinyDB) -> list:
    return db.table(collection).all()

def find(collection: str, field: str, value, db: TinyDB) -> list:
    q = Query()
    return db.table(collection).search(q[field] == value)

def update(collection: str, field: str, value, updates: dict, db: TinyDB) -> int:
    q = Query()
    return db.table(collection).update(updates, q[field] == value)

def delete_by_field(collection: str, field: str, value, db: TinyDB) -> int:
    q = Query()
    return db.table(collection).remove(q[field] == value)