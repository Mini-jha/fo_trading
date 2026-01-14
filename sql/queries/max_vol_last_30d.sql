WITH max_dt AS (
    SELECT MAX(trade_date) AS max_trade_date
    FROM trades
)
SELECT
    i.symbol,
    MAX(t.volume) AS max_volume
FROM trades t
JOIN instruments i ON t.instrument_id = i.instrument_id
JOIN max_dt m ON t.trade_date >= m.max_trade_date - INTERVAL '30 days'
GROUP BY i.symbol
ORDER BY max_volume DESC
limit 5;


######output

  symbol   | max_volume 
-----------+------------
 BANKNIFTY |    4564524
 NIFTY     |    1274605
 YESBANK   |     215823
 INFY      |      84779
 SBIN      |      83986
(5 rows)