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

WITH total_sales AS (
    SELECT sales_reps.id AS rep_id, SUM(total_amt_usd) AS total_sales
    FROM sales_reps
        JOIN accounts
        ON accounts.sales_rep_id = sales_reps.id
        JOIN orders
        ON orders.account_id = accounts.id
    GROUP BY sales_reps.id
)
SELECT sales_reps.name AS rep_name, region.name AS region_name,
        MAX(total_sales.total_sales) AS total_sales
FROM sales_reps
    JOIN total_sales
    ON total_sales.rep_id = sales_reps.id
    JOIN region
    ON region.id = sales_reps.region_id
GROUP BY sales_reps.name, region.name
ORDER BY total_sales DESC
;

-- Next try
WITH total_sales AS (
    SELECT sales_reps.id AS rep_id, sales_reps.name AS rep_name,
            region.id AS region_id, region.name AS region_name,
            SUM(total_amt_usd) AS total_sales
    FROM sales_reps
        JOIN region
        ON region.id = sales_reps.region_id
        JOIN accounts
        ON accounts.sales_rep_id = sales_reps.id
        JOIN orders
        ON orders.account_id = accounts.id
    GROUP BY sales_reps.id, sales_reps.name, region.id, 
            region.name
)
SELECT total_sales.rep_name AS rep_name, total_sales.region_name AS region_name,
        total_sales.total_sales AS total_sales
FROM total_sales
    JOIN accounts
    ON accounts.sales_rep_id = total_sales.rep_id
    JOIN orders
    ON orders.account_id = accounts.id
GROUP BY total_sales.rep_name, total_sales.region_name, total_sales.total_sales
HAVING total_sales = SUM(orders.total_amt_usd)
ORDER BY region_name, total_sales DESC

-- 2. For the region with the largest sales total_amt_usd, how many total orders were placed?
WITH region_with_most_sales AS (
    SELECT region.id, region.name, SUM(orders.total_amt_usd) AS total_sales
    FROM region
        JOIN sales_reps
        ON sales_reps.region_id = region.id
        JOIN accounts
        ON accounts.sales_rep_id = sales_reps.id
        JOIN orders
        ON orders.account_id = accounts.id
    GROUP BY region.id, region.name
    ORDER BY total_sales DESC
    LIMIT 1
)
SELECT region_with_most_sales.id, region_with_most_sales.name, region_with_most_sales.total_sales, COUNT(*) AS total_orders
FROM sales_reps
        JOIN region_with_most_sales
        ON sales_reps.region_id = region_with_most_sales.id
        JOIN accounts
        ON accounts.sales_rep_id = sales_reps.id
        JOIN orders
        ON orders.account_id = accounts.id
GROUP BY region_with_most_sales.id, region_with_most_sales.name, region_with_most_sales.total_sales

-- 3. How many accounts had more total purchases than the account name which has bought the most standard_qty
--    paper throughout their lifetime as a customer?
WITH t1 AS (
    SELECT accounts.id, SUM(orders.standard_qty) AS total_standard_qty, COUNT(*) AS total_orders
    FROM accounts
        JOIN orders
        ON orders.account_id = accounts.id
    GROUP BY accounts.id
    ORDER BY total_standard_qty DESC
    LIMIT 1
), t2 AS (
    SELECT orders.account_id, COUNT(orders.total) AS total_orders
    FROM orders
        JOIN t1
        ON t1.id != orders.account_id 
    GROUP BY orders.account_id
)
SELECT t2.account_id, t2.total_orders
FROM t2
    JOIN t1
    ON t1.id != t2.account_id 
WHERE t2.total_orders > t1.total_standard_qty
ORDER BY t2.total_orders

-- 4. For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many
--    web_events did they have for each channel?
WITH t1 AS (
    SELECT accounts.id AS account_id, accounts.name AS account_name, SUM(orders.total_amt_usd) AS total_usd
    FROM accounts
        JOIN orders
        ON orders.account_id = accounts.id
    GROUP BY accounts.id, accounts.name
    ORDER BY total_usd DESC
    LIMIT 1
)
SELECT t1.account_name, web_events.channel, COUNT(web_events.channel) AS channel_count
FROM web_events
    JOIN t1
    ON t1.account_id = web_events.account_id
GROUP BY t1.account_name, web_events.channel
ORDER BY channel_count DESC

-- 5. What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?
WITH t1 AS (
    SELECT accounts.id, accounts.name, SUM(orders.total_amt_usd) AS total
    FROM accounts
        JOIN orders
        ON orders.account_id = accounts.id
    GROUP BY accounts.id, accounts.name
    ORDER BY total DESC
    LIMIT 10
)
SELECT AVG(t1.total)
FROM t1;

-- 6. What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent
--    more per order, on average, than the average of all orders.
WITH t1 AS (
   SELECT AVG(o.total_amt_usd) avg_all
   FROM orders o
   JOIN accounts a
   ON a.id = o.account_id),
t2 AS (
   SELECT o.account_id, AVG(o.total_amt_usd) avg_amt
   FROM orders o
   GROUP BY 1
   HAVING AVG(o.total_amt_usd) > (SELECT * FROM t1))
SELECT AVG(avg_amt)
FROM t2;