CREATE INDEX idx_trades_timestamp ON trades USING BRIN(timestamp);
CREATE INDEX idx_trades_trade_date ON trades(trade_date);
CREATE INDEX idx_instruments_symbol ON instruments(symbol);
