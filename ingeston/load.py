import pandas as pd
from sqlalchemy import create_engine

DB_URL = "postgresql+psycopg2://postgres:postgres@localhost:5432/fo_trading"
engine = create_engine(DB_URL)

print("Reading CSV...")
df = pd.read_csv("../3mfanddo.csv")
df.columns = df.columns.str.lower()
df = df.drop(columns=['unnamed: 0'])

df['expiry_dt'] = pd.to_datetime(df['expiry_dt']).dt.date


# Normalize numeric fields
df['strike_pr'] = df['strike_pr'].fillna(0).round(2)

# --------------------
# Insert instruments
# --------------------
instruments = (
    df[['symbol', 'instrument']]
    .drop_duplicates()
    .rename(columns={'instrument': 'instrument_type'})
)

instruments['exchange_id'] = 1
instruments['underlying'] = instruments['symbol']

instruments = instruments.drop_duplicates(subset=['symbol'])

instruments.to_sql(
    'instruments',
    engine,
    if_exists='append',
    index=False
)

instrument_map = pd.read_sql(
    "SELECT instrument_id, symbol FROM instruments",
    engine
)

df = df.merge(instrument_map, on='symbol', how='inner')

# --------------------
# Insert expiries
# --------------------

expiries = (
    df[['expiry_dt', 'strike_pr', 'option_typ', 'instrument_id']]
    .drop_duplicates()
)
expiries['expiry_dt'] = pd.to_datetime(expiries['expiry_dt']).dt.date


expiries.to_sql(
    'expiries',
    engine,
    if_exists='append',
    index=False
)

expiry_map = pd.read_sql("""
    SELECT expiry_id, expiry_dt, strike_pr, option_typ, instrument_id
    FROM expiries
""", engine)

print(df[['expiry_dt', 'strike_pr', 'option_typ']].head())
print(expiry_map[['expiry_dt', 'strike_pr', 'option_typ']].head())


df = df.merge(
    expiry_map,
    on=['expiry_dt', 'strike_pr', 'option_typ', 'instrument_id'],
    how='inner'
)

print("Rows after expiry join:", len(df))

# --------------------
# Insert trades
# --------------------
df['timestamp'] = pd.to_datetime(df['timestamp'])
df['trade_date'] = df['timestamp'].dt.date

trades = df.rename(columns={
    'open': 'open_pr',
    'high': 'high_pr',
    'low': 'low_pr',
    'close': 'close_pr',
    'contracts': 'volume'
})

trades = trades[[
    'instrument_id', 'expiry_id', 'trade_date',
    'open_pr', 'high_pr', 'low_pr',
    'close_pr', 'settle_pr',
    'volume', 'open_int', 'timestamp'
]]

trades.to_sql(
    'trades',
    engine,
    if_exists='append',
    index=False,
    method='multi',
    chunksize=50000
)

print("✅ Data ingestion completed successfully")
