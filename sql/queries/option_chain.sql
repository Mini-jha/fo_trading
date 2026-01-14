SELECT
    ex.expiry_dt,
    ex.strike_pr,
    SUM(t.volume) AS implied_volume,
    COUNT(DISTINCT i.symbol) AS symbol_count
FROM trades t
JOIN expiries ex ON t.expiry_id = ex.expiry_id
JOIN instruments i ON t.instrument_id = i.instrument_id
GROUP BY ex.expiry_dt, ex.strike_pr
ORDER BY ex.expiry_dt, ex.strike_pr
limit 5;




#####output

 expiry_dt  | strike_pr | implied_volume | symbol_count 
------------+-----------+----------------+--------------
 2019-08-01 |   9600.00 |             10 |            1
 2019-08-01 |   9650.00 |              0 |            1
 2019-08-01 |   9700.00 |             63 |            1
 2019-08-01 |   9750.00 |              0 |            1
 2019-08-01 |   9800.00 |             16 |            1
(5 rows)
