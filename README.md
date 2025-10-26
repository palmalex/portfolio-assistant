# Portfolio Assistant

A FastAPI application for managing investment portfolios.

## Features

- Buy and sell assets
- Track transactions
- Portfolio management
- Memory or file-based database
- REST API endpoints

## Installation

```bash
# Create and activate virtual environment
python -m venv .venv
.venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

## Testing

```bash
# Run all tests
python -m pytest

# Run with verbose output
python -m pytest -v
```

## Running the Application

```bash
# Start the FastAPI server with hot reload
uvicorn src.main:app --reload
```

## API Endpoints

- `POST /buy` - Record a buy transaction
- `POST /sell` - Record a sell transaction
- `GET /portfolio/{user_id}` - Get user's portfolio

## Project Structure

```
portfolio-assistant/
├── src/
│   ├── crud/       # Database operations
│   ├── services/   # Business logic
│   └── main.py     # FastAPI application
├── tests/          # Test files
└── README.md
```

## License

MIT License