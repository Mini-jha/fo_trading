SELECT
    symbol,
    total_volume,
    RANK() OVER (ORDER BY total_volume DESC) AS volume_rank
FROM (
    SELECT
        i.symbol,
        SUM(t.volume) AS total_volume
    FROM trades t
    JOIN instruments i ON t.instrument_id = i.instrument_id
    GROUP BY i.symbol
) ranked_symbols
limit 5;


####output
  symbol   | total_volume | volume_rank 
-----------+--------------+-------------
 BANKNIFTY |   1003241488 |           1
 NIFTY     |    440654970 |           2
 YESBANK   |     10161042 |           3
 RELIANCE  |      7781761 |           4
 SBIN      |      6184575 |           5
(5 rows)