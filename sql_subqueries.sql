-- Find the number of events the occur for each day for each channel
SELECT channel, DATE_TRUNC('day', occurred_at) AS date, COUNT(*) AS events
	FROM web_events
	GROUP BY channel, DATE_TRUNC('day', occurred_at)
    ORDER BY events DESC;