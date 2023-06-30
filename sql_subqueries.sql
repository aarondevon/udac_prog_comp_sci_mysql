-- Find the number of events that occur for each day for each channel
SELECT channel, DATE_TRUNC('day', occurred_at) AS date, COUNT(*) AS events
	FROM web_events
	GROUP BY channel, DATE_TRUNC('day', occurred_at)
    ORDER BY events DESC;

-- Create a subquery that provides all of the data from the query above
SELECT *
FROM (SELECT channel, DATE_TRUNC('day', occurred_at) AS date, COUNT(*) AS events
	FROM web_events
	GROUP BY channel, DATE_TRUNC('day', occurred_at)
    ORDER BY events DESC) AS sub;

-- Find the average number of events from each channel
SELECT channel, ROUND(AVG(events), 2) AS average_events_per_day
FROM (SELECT channel, DATE_TRUNC('day', occurred_at) AS date, COUNT(*) AS events
	FROM web_events
	GROUP BY channel, DATE_TRUNC('day', occurred_at)
    ORDER BY events DESC) AS sub
GROUP BY channel
ORDER BY average_events_per_day DESC;

-- Use DATE_TRUNC to pull month level information about the first order ever placed
SELECT DATE_TRUNC('month', MIN(occurred_at))
FROM orders;

/* 
Use the result of the previous querry to find the orders that took place in the same month and year
as the first order, and then pull the average for each type of paper quantity in this month. Also,
pull total sales amount for the same month and year
*/
SELECT  
        AVG(standard_qty) AS avg_standard_qty, 
        AVG(gloss_qty) AS avg_gloss_qty, 
        AVG(poster_qty) AS avg_poster_qty,
        SUM(total_amt_usd)
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = (SELECT DATE_TRUNC('month', MIN(occurred_at))
            FROM orders);

-- What is the top channel used by each account to market products?
-- How often was that same channel used?
WITH cte_2 AS (SELECT account_id, channel, COUNT(*) as times_used
FROM web_events
GROUP BY account_id, channel)

SELECT *
FROM cte_2

WITH cte_1 AS 
(SELECT accounts.name, web_events.channel, COUNT(*) AS used
FROM web_events
JOIN accounts
ON web_events.account_id = accounts.id
GROUP BY accounts.name, web_events.channel
ORDER BY accounts.name, used)

SELECT *
FROM cte_1
ORDER BY name, used DESC;

SELECT *
FROM
(SELECT account_id, channel, COUNT(*) AS used
FROM web_events
GROUP BY accounts.name, web_events.channel
ORDER BY accounts.name, used) AS etd 
GROUP BY name, channel, used
HAVING name = name and used = MAX(used)
ORDER BY name, used DESC

SELECT *
FROM
(SELECT account_id, channel, COUNT(*) AS channel_count
FROM web_events
GROUP BY account_id, web_events.channel
ORDER BY account_id, used DESC) AS etd

SELECT account.name, web_events.account_id
FROM accounts
JOIN web_events
ON accounts.id = web_events.accounts;



WITH top_channels AS (SELECT account_id, channel, COUNT(channel) AS channel_count
FROM web_events
GROUP BY account_id, channel
order by account_id, channel_count DESC
),
table_two AS (SELECT *, row_number() over (partition by account_id, channel, channel_count ORDER BY account_id, channel, channel_count DESC) AS rn FROM top_channels
)

SELECT *
FROM table_two
ORDER BY account_id, channel





WITH top_channels AS (SELECT account_id, channel, COUNT(channel) AS channel_count
FROM web_events
GROUP BY account_id, channel
order by account_id, channel_count DESC
),
table_two AS (SELECT *, row_number() over (partition by account_id, channel, channel_count ORDER BY account_id, channel, channel_count DESC) AS rn FROM top_channels
)

SELECT *
FROM table_two
ORDER BY account_id, channel