EXPLAIN ANALYZE
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



Sort  (cost=68181.71..68182.12 rows=164 width=16) (actual time=1265.955..1265.965 rows=152 loops=1)
   Sort Key: (max(t.volume)) DESC
   Sort Method: quicksort  Memory: 34kB
   ->  HashAggregate  (cost=68174.04..68175.68 rows=164 width=16) (actual time=1264.252..1264.281 rows=152 loops=1)
         Group Key: i.symbol
         Batches: 1  Memory Usage: 48kB
         ->  Hash Join  (cost=9266.58..63952.10 rows=844388 width=16) (actual time=161.811..1143.757 rows=749379 loops=1)
               Hash Cond: (t.instrument_id = i.instrument_id)
               ->  Nested Loop  (cost=9260.89..61672.61 rows=844388 width=12) (actual time=160.357..1030.255 rows=749379 loops=1)
                     ->  Result  (cost=0.45..0.46 rows=1 width=4) (actual time=3.278..3.280 rows=1 loops=1)
                           InitPlan 1 (returns $0)
                             ->  Limit  (cost=0.43..0.45 rows=1 width=4) (actual time=3.274..3.276 rows=1 loops=1)
                                   ->  Index Only Scan Backward using idx_trades_trade_date on trades  (cost=0.43..52466.78 rows=2533163 width=4) (actual time=3.256..3.256 rows=1 loops=1)
                                         Index Cond: (trade_date IS NOT NULL)
                                         Heap Fetches: 0
                     ->  Bitmap Heap Scan on trades t  (cost=9260.44..53228.26 rows=844388 width=16) (actual time=157.068..933.726 rows=749379 loops=1)
                           Recheck Cond: (trade_date >= (($0) - '30 days'::interval))
                           Heap Blocks: exact=9284
                           ->  Bitmap Index Scan on idx_trades_trade_date  (cost=0.00..9049.34 rows=844388 width=0) (actual time=155.386..155.386 rows=749379 loops=1)        
                                 Index Cond: (trade_date >= (($0) - '30 days'::interval))
               ->  Hash  (cost=3.64..3.64 rows=164 width=12) (actual time=0.702..0.703 rows=164 loops=1)
                     Buckets: 1024  Batches: 1  Memory Usage: 16kB
                     ->  Seq Scan on instruments i  (cost=0.00..3.64 rows=164 width=12) (actual time=0.129..0.148 rows=164 loops=1)
 Planning Time: 21.238 ms
 Execution Time: 1271.687 ms
(25 rows)
