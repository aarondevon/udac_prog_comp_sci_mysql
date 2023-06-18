-- Find the total amount of poster_qty paper ordered in the orders table.
SELECT SUM(poster_qty) AS poster_total_ordered
FROM orders;

-- Find the total amount of standard_qty paper ordered in the orders table.
SELECT SUM(standard_qty) AS standard_total_ordered
FROM orders;

-- Find the total dollar amount of sales using the total_amt_usd in the orders table.
SELECT SUM(total_amt_usd) AS total_usd
FROM orders;

-- Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table. This should give a dollar amount for each order in the table.
SELECT SUM(standard_amt_usd) + SUM(gloss_amt_usd) AS total_gloss_and_standard_usd
FROM orders;

-- Find the standard_amt_usd per unit of standard_qty paper. Your solution should use both aggregation and a mathematical operator.
SELECT ROUND(SUM(standard_amt_usd) / SUM(standard_qty), 2) AS standard_unit_price
FROM orders;

-- When was the earliest order ever placed? You only need to return the date.
SELECT MIN(occurred_at)
FROM orders;

-- Try performing the same query as in question 1 without using an aggregation function.
SELECT occurred_at
FROM orders
ORDER BY occurred_at
LIMIT 1;

-- When did the most recent (latest) web_event occur?
SELECT MAX
(occurred_at)
FROM web_events;

-- Try to perform the result of the previous query without using an aggregation function.
SELECT occurred_at
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1;

-- Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean amount of each paper type purchased per order. Your final answer should have 6 values - one for each paper type for the average number of sales, as well as the average amount.
SELECT ROUND
(AVG
(standard_amt_usd), 2) AS standard_amt_average,
ROUND
(AVG
(gloss_amt_usd), 2) AS gloss_amt_average,
ROUND
(AVG
(poster_amt_usd), 2) AS poster_amt_average,
ROUND
(AVG
(standard_qty)) AS standard_qty_average,
ROUND
(AVG
(gloss_qty)) AS gloss_qty_average,
ROUND
(AVG
(poster_qty)) AS poster_qty_average
FROM orders;

-- Via the video, you might be interested in how to calculate the MEDIAN. Though this is more advanced than what we have covered so far try finding - what is the MEDIAN total_usd spent on all orders?
