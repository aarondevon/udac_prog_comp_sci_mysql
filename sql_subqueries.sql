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
