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

## Database Design Rationale

### Normalization Strategy

The database schema is normalized to **Third Normal Form (3NF)** to eliminate redundancy and ensure data integrity.  
Each real-world entity (exchange, instrument, expiry, trade) is modeled as a separate table with clearly defined primary and foreign keys.

- **Exchanges** are stored independently to support multi-exchange analytics (NSE, BSE, MCX)
- **Instruments** abstract tradable symbols and underlyings
- **Expiries** are separated to efficiently handle strike prices and option types
- **Trades** act as the fact table containing time-series OHLC and volume data

This design avoids duplication of instrument and expiry metadata across millions of trade records.

---

### Why Star Schema Was Avoided

A star schema was intentionally avoided because:

- F&O datasets are **high-frequency and write-heavy**
- Star schemas introduce **duplication of dimension attributes**
- Frequent updates and inserts significantly increase **storage and maintenance overhead**

A normalized, OLTP-friendly design ensures **accurate transactional representation**, which is critical for trading analytics.

---

### Scalability Considerations (10M+ Rows)

The schema is designed to scale to **10M+ rows** by:

- Separating dimension tables from fact data
- Supporting table partitioning on `trade_date` or `exchange`
- Enabling time-series indexing strategies such as **BRIN** and **B-Tree**
- Allowing parallel ingestion via bulk inserts

This makes the design suitable for **HFT-like ingestion and analytical workloads**.


## How to Run
```bash
docker compose up -d
python ingestion/load.py


