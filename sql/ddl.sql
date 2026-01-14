CREATE TABLE exchanges (
    exchange_id SERIAL PRIMARY KEY,
    exchange_name VARCHAR(10) UNIQUE NOT NULL
);

INSERT INTO exchanges (exchange_name)
VALUES ('NSE'), ('BSE'), ('MCX');

CREATE TABLE instruments (
    instrument_id SERIAL PRIMARY KEY,
    symbol VARCHAR(50),
    instrument_type VARCHAR(10),
    underlying VARCHAR(50),
    exchange_id INT REFERENCES exchanges(exchange_id)
);

CREATE TABLE expiries (
    expiry_id SERIAL PRIMARY KEY,
    expiry_dt DATE,
    strike_pr NUMERIC(10,2),
    option_typ VARCHAR(2),
    instrument_id INT REFERENCES instruments(instrument_id)
);

CREATE TABLE trades (
    trade_id BIGSERIAL PRIMARY KEY,
    instrument_id INT REFERENCES instruments(instrument_id),
    expiry_id INT REFERENCES expiries(expiry_id),
    trade_date DATE,
    open_pr NUMERIC(10,2),
    high_pr NUMERIC(10,2),
    low_pr NUMERIC(10,2),
    close_pr NUMERIC(10,2),
    settle_pr NUMERIC(10,2),
    volume BIGINT,
    open_int BIGINT,
    timestamp TIMESTAMP
);

