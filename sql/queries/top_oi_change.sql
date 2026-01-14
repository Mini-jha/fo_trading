SELECT
    i.symbol,
    e.exchange_name,
    SUM(t.open_int) AS total_open_interest
FROM trades t
JOIN instruments i ON t.instrument_id = i.instrument_id
JOIN exchanges e ON i.exchange_id = e.exchange_id
GROUP BY i.symbol, e.exchange_name
ORDER BY total_open_interest DESC
LIMIT 10;


#####output
   symbol   | exchange_name | total_open_interest
------------+---------------+---------------------
 IDEA       | NSE           |         52658340000
 YESBANK    | NSE           |         19227696400
 IDFCFIRSTB | NSE           |         17283144000
 SBIN       | NSE           |         12908568000
 GMRINFRA   | NSE           |         12777705000
 PNB        | NSE           |         10371077000
 ITC        | NSE           |          9221930400
 SAIL       | NSE           |          9105950400
 ASHOKLEY   | NSE           |          8830896000
 NIFTY      | NSE           |          8666490975
(10 rows)
