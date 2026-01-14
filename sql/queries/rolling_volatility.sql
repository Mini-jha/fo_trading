SELECT
    t.trade_date,
    i.symbol,
    STDDEV(t.close_pr) OVER (
        PARTITION BY i.symbol
        ORDER BY t.trade_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS rolling_7d_volatility
FROM trades t
JOIN instruments i ON t.instrument_id = i.instrument_id
WHERE i.symbol = 'NIFTY'
ORDER BY t.trade_date
limit 5;
