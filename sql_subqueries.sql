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