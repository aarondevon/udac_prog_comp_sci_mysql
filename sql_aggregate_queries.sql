-- Find the total amount of poster_qty paper ordered in the orders table.

SELECT SUM(poster_qty) AS poster_total_ordered FROM orders;

-- Find the total amount of standard_qty paper ordered in the orders table.

SELECT SUM(standard_qty) AS standard_total_ordered FROM orders;

-- Find the total dollar amount of sales using the total_amt_usd in the orders table.

SELECT SUM(total_amt_usd) AS total_usd FROM orders;

-- Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table. This should give a dollar amount for each order in the table.

SELECT
    SUM(standard_amt_usd) + SUM(gloss_amt_usd) AS total_gloss_and_standard_usd
FROM orders;

-- Find the standard_amt_usd per unit of standard_qty paper. Your solution should use both aggregation and a mathematical operator.

SELECT
    ROUND(
        SUM(standard_amt_usd) / SUM(standard_qty),
        2
    ) AS standard_unit_price
FROM orders;

-- When was the earliest order ever placed? You only need to return the date.

SELECT MIN(occurred_at) FROM orders;

-- Try performing the same query as in question 1 without using an aggregation function.

SELECT occurred_at FROM orders ORDER BY occurred_at LIMIT 1;

-- When did the most recent (latest) web_event occur?

SELECT MAX (occurred_at) FROM web_events;

-- Try to perform the result of the previous query without using an aggregation function.

SELECT occurred_at FROM web_events ORDER BY occurred_at DESC LIMIT 1;

-- Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean amount of each paper type purchased per order. Your final answer should have 6 values - one for each paper type for the average number of sales, as well as the average amount.

SELECT
    ROUND (AVG (standard_amt_usd), 2) AS standard_amt_average,
    ROUND (AVG (gloss_amt_usd), 2) AS gloss_amt_average,
    ROUND (AVG (poster_amt_usd), 2) AS poster_amt_average,
    ROUND (AVG (standard_qty)) AS standard_qty_average,
    ROUND (AVG (gloss_qty)) AS gloss_qty_average,
    ROUND (AVG (poster_qty)) AS poster_qty_average
FROM orders;

-- Via the video, you might be interested in how to calculate the MEDIAN. Though this is more advanced than what we have covered so far try finding - what is the MEDIAN total_usd spent on all orders?

-- Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.
SELECT accounts.name, orders.occurred_at AS earliest_order
FROM accounts
    JOIN orders 
    ON accounts.id = orders.account_id
ORDER BY earliest_order
LIMIT 1;

-- Find the total sales in usd for each account. You should include two columns - the total sales for each company's orders in usd and the company name.
SELECT accounts.name, SUM (orders.total_amt_usd) AS total_sales
FROM accounts
    JOIN orders 
    ON accounts.id = orders.account_id
GROUP BY accounts.name
ORDER BY total_sales;

-- Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event? Your query should return only three values - the date, channel, and account name.
SELECT web_events.occurred_at AS most_recent_event, web_events.channel, accounts.name
FROM accounts
  JOIN web_events 
  ON accounts.id = web_events.account_id
ORDER BY most_recent_event DESC
LIMIT 1;

-- Find the total number of times each type of channel from the web_events was used. Your final table should have two columns - the channel and the number of times the channel was used.
SELECT channel, COUNT(*) AS times_used
FROM web_events
GROUP BY channel
ORDER BY times_used;
-- Who was the primary contact associated with the earliest web_event?
SELECT accounts.primary_poc, web_events.channel, web_events.occurred_at AS earliest_event
FROM accounts
  JOIN web_events 
  ON accounts.id = web_events.account_id
ORDER BY earliest_event
LIMIT 1;
-- What was the smallest order placed by each account in terms of total usd. Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.
SELECT accounts.name, MIN (orders.total_amt_usd) AS smallest_order
FROM accounts
  JOIN orders 
  ON accounts.id = orders.account_id
GROUP BY accounts.name
ORDER BY smallest_order;
-- Find the number of sales reps in each region. Your final table should have two columns - the region and the number of sales_reps. Order from the fewest reps to most reps.
SELECT region.name, COUNT(*) AS number_of_reps
FROM sales_reps
  JOIN region 
  ON sales_reps.region_id = region.id
GROUP BY region.name
ORDER BY number_of_reps;

-- For each account, determine the average amount of each type of paper they purchased across their orders. Your result should have four columns - one for the account name and one for the average quantity purchased for each of the paper types for each account.
SELECT accounts.name, 
	ROUND(AVG(standard_qty)) AS standard_avg,
    ROUND(AVG(gloss_qty)) AS gloss_avg, 
    ROUND(AVG(poster_qty)) AS poster_avg
FROM accounts
    JOIN orders
    ON accounts.id = orders.account_id
GROUP BY accounts.name;

-- For each account, determine the average amount spent per order on each paper type. Your result should have four columns - one for the account name and one for the average amount spent on each paper type.
SELECT accounts.name, 
	ROUND(AVG(standard_amt_usd), 2) AS standard_avg_usd,
    ROUND(AVG(gloss_amt_usd), 2) AS gloss_avg_usd, 
    ROUND(AVG(poster_amt_usd), 2) AS poster_avg_usd
FROM accounts
    JOIN orders
    ON accounts.id = orders.account_id
GROUP BY accounts.name;

-- Determine the number of times a particular channel was used in the web_events table for each sales rep. Your final table should have three columns - the name of the sales rep, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.
SELECT sales_reps.name, 
    web_events.channel, 
    COUNT(*) AS number_of_events
FROM sales_reps
    JOIN accounts
    ON sales_reps.id = accounts.sales_rep_id
    JOIN web_events
    ON accounts.id = web_events.account_id
GROUP BY sales_reps.name, web_events.channel
ORDER BY number_of_events DESC;

-- Determine the number of times a particular channel was used in the web_events table for each region. Your final table should have three columns - the region name, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.
SELECT region.name, web_events.channel, COUNT(*) AS number_of_events
FROM region
    JOIN sales_reps
    ON region.id = sales_reps.region_id
    JOIN accounts
    ON sales_reps.id = accounts.sales_rep_id
    JOIN web_events
    ON accounts.id = web_events.account_id
GROUP BY region.name, web_events.channel
ORDER BY number_of_events DESC;

-- Use DISTINCT to test if there are any accounts associated with more than one region.
SELECT accounts.name AS account_name,
                region.name AS region_name
FROM accounts
    JOIN sales_reps
    ON accounts.sales_rep_id = sales_reps.id
    JOIN region
    ON sales_reps.region_id = region.id
ORDER BY account_name;

-- and
SELECT DISTINCT id, name
FROM accounts;

-- Have any sales reps worked on more than one account?
SELECT accounts.name AS account_name,
                sales_reps.name AS rep_name
FROM accounts
    JOIN sales_reps
    ON accounts.sales_rep_id = sales_reps.id
ORDER BY rep_name;

-- and

SELECT DISTINCT id, name
FROM sales_reps;

-- How many of the sales reps have more than 5 accounts that they manage?
SELECT sales_reps.name, COUNT(*) AS number_of_accounts
FROM sales_reps
    JOIN accounts
    ON sales_reps.id = accounts.sales_rep_id
GROUP BY sales_reps.name
HAVING COUNT(*) > 5
ORDER BY sales_reps.name;

-- How many accounts have more than 20 orders?
SELECT accounts.name, COUNT(*) AS number_of_orders
FROM accounts
    JOIN orders
    ON accounts.id = orders.account_id
GROUP BY accounts.name
HAVING COUNT(*) > 20
ORDER BY accounts.name;

-- Which account has the most orders?
SELECT accounts.name, COUNT(*) AS number_of_orders
FROM accounts
    JOIN orders
    ON accounts.id = orders.account_id
GROUP BY accounts.name
ORDER BY number_of_orders DESC
LIMIT 1;

-- Which accounts spent more than 30,000 usd total across all orders?
SELECT accounts.name, SUM(orders.total_amt_usd) AS total_spent
FROM accounts
    JOIN orders
    ON accounts.id = orders.account_id
GROUP BY accounts.name
HAVING SUM(orders.total_amt_usd) > 30000
ORDER BY total_spent;

-- Which accounts spent less than 1,000 usd total across all orders?
SELECT accounts.name, SUM(orders.total_amt_usd) AS total_spent
FROM accounts
    JOIN orders
    ON accounts.id = orders.account_id
GROUP BY accounts.name
HAVING SUM(orders.total_amt_usd) < 1000
ORDER BY total_spent;

-- Which account has spent the most with us?
SELECT accounts.name, SUM(orders.total_amt_usd) AS total_spent
FROM accounts
    JOIN orders
    ON accounts.id = orders.account_id
GROUP BY accounts.name
HAVING SUM(orders.total_amt_usd) > 30000
ORDER BY total_spent DESC
LIMIT 1;

-- Which account has spent the least with us?
-- Finds account that has spen 0.00
SELECT accounts.name, SUM(orders.total_amt_usd) total_spent
FROM accounts
    JOIN orders
    ON accounts.id = orders.account_id
GROUP BY accounts.name
HAVING SUM(orders.total_amt_usd) < 1000
ORDER BY total_spent
LIMIT 1;
-- Finds account which has spent more than 0.00 but has spent the least amount
SELECT accounts.name, orders.total_amt_usd
FROM accounts
    JOIN orders
    ON accounts.id = orders.account_id
GROUP BY accounts.name, orders.total_amt_usd
HAVING orders.total_amt_usd > 0.00
ORDER BY orders.total_amt_usd
LIMIT 1;

-- Which accounts used facebook as a channel to contact customers more than 6 times?
SELECT accounts.name, web_events.channel, COUNT(*) times_chan_used
FROM accounts
    JOIN web_events
    ON accounts.id = web_events.account_id 
    AND web_events.name = 'facebook'
GROUP BY accounts.name, web_events.channel
HAVING COUNT(*) > 6;

-- Which account used facebook most as a channel?
SELECT accounts.name, web_events.channel, COUNT(*) times_chan_used
FROM accounts
    JOIN web_events
    ON accounts.id = web_events.account_id
    AND web_events.channel = 'facebook'
GROUP BY accounts.name, web_events.channel
HAVING COUNT(*) > 6
ORDER BY times_chan_used DESC
LIMIT 1;

-- Which channel was most frequently used by most accounts?
SELECT web_events.channel, COUNT(*) times_chan_used
FROM accounts
    JOIN web_events
    ON accounts.id = web_events.account_id
GROUP BY web_events.channel
ORDER BY times_chan_used DESC
LIMIT 1;