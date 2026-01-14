# Futures & Options Trading Database (PostgreSQL)

## Objective
Design and implement a normalized relational database to store and analyze
high-volume Futures & Options (F&O) data across Indian exchanges (NSE, BSE, MCX).

## Tech Stack
- PostgreSQL 14 (Docker)
- Python (Pandas, SQLAlchemy)
- VS Code
- DuckDB / PostgreSQL compatible SQL

## Dataset
NSE Future and Options Dataset (3 Months) from Kaggle  
~2.5M+ rows of real market data

## Schema Design
- 3NF normalized schema
- Dimension tables: exchanges, instruments, expiries
- Fact table: trades
- Supports multi-exchange analytics

## Ingestion
- Bulk CSV ingestion using Pandas
- Foreign key resolution before fact load
- Chunked inserts for performance

## Performance Optimizations
- Indexes on timestamp, instrument_id, expiry_id
- Ready for partitioning by trade_date
- Optimized joins for analytical queries

## How to Run
```bash
docker compose up -d
python ingestion/load.py
