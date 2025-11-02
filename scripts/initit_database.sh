#!/bin/bash
# ============================================================
# Portfolio Assistant - Database Initialization Script
# Version: 1.2 (November 2025)
# Author: Laura (Senior Data Model Analyst)
# ============================================================

set -e

DB_PATH="./database/portfolio_assistant.db"
SCHEMA_PATH="./database/schema.sql"
SAMPLE_DATA_PATH="./database/sample_data.sql"

echo "🔧 Initializing Portfolio Assistant database..."

# Remove existing DB if present
if [ -f "$DB_PATH" ]; then
  echo "🗑️  Removing existing database file..."
  rm "$DB_PATH"
fi

# Ensure SQLite is installed
if ! command -v sqlite3 &> /dev/null; then
  echo "❌ sqlite3 not found. Please install it before running this script."
  exit 1
fi

# Create database and load schema
echo "📜 Loading schema..."
sqlite3 "$DB_PATH" < "$SCHEMA_PATH"

# Load sample data
echo "💾 Loading sample data..."
sqlite3 "$DB_PATH" < "$SAMPLE_DATA_PATH"

# Verify tables exist
echo "🔍 Verifying database contents..."
sqlite3 "$DB_PATH" ".tables"

echo "✅ Database initialization complete!"
echo "Database file created at: $DB_PATH"
