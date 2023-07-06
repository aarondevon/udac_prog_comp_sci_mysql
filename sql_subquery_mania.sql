-- 1. Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.

sales_rep.name, region.name, 




SELECT sales_reps.id AS rep_id, sales_reps.name AS rep_name, 
                region.id AS region_id, region.name AS region_name
FROM sales_reps
JOIN region
ON sales_reps.region_id = region.id
ORDER BY rep_name;

SELECT sales_reps.name, thing_2.id, thing_2.region_name, thing_2.money
FROM (
    SELECT region.id, region_name, MAX(sum) as money
    FROM (
        SELECT sales_reps.name, region.id, region.name AS region_name, SUM(orders.total_amt_usd)
        FROM sales_reps
            JOIN region
            ON sales_reps.region_id = region.id
            JOIN accounts
            ON sales_reps.id = accounts.sales_rep_id
            JOIN orders
            ON accounts.id = orders.account_id
        GROUP BY sales_reps.name, region.id, region.name 
        ORDER BY region.name, sum DESC
        ) as thing
    GROUP BY region.id, region_name
) AS thing_2
JOIN (
SELECT sales_reps.name, region.id, region.name AS region_name, SUM(orders.total_amt_usd)
        FROM sales_reps
            JOIN region
            ON sales_reps.region_id = region.id
            JOIN accounts
            ON sales_reps.id = accounts.sales_rep_id
            JOIN orders
            ON accounts.id = orders.account_id
        GROUP BY sales_reps.name, region.id, region.name 
        ORDER BY region.name, sum DESC
    ) AS thing_3
ON  thing_2.id = thing_3.region.id
    AND thing_2.money = thing_3.sum

-- 2. For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?


-- 3. How many accounts had more total purchases than the account name which has bought the most
--    standard_qty paper throughout their lifetime as a customer?

-- 4. For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd,
--    how many web_events did they have for each channel?

-- 5. What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?

-- 6. What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent
--    more per order, on average, than the average of all orders?

-- USING CTE
-- Find the average number of events for each channel per day .
WITH events AS (
SELECT DATE_TRUNC('day',occurred_at) AS day, channel, COUNT(*) AS events
FROM web_events 
GROUP BY day, channel
)
SELECT channel, AVG(events) AS average_events
FROM events
GROUP BY channel
ORDER BY average_events DESC;

-- 1. Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.

-- 2. For the region with the largest sales total_amt_usd, how many total orders were placed?

-- 3. How many accounts had more total purchases than the account name which has bought the most standard_qty
--    paper throughout their lifetime as a customer?

-- 4. For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many
--    web_events did they have for each channel?

-- 5. What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?

-- 6. What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent
--    more per order, on average, than the average of all orders.
