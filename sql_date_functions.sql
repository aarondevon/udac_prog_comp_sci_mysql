-- Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. Do you notice any trends in the yearly sales totals?
SELECT DATE_PART('year', orders.occurred_at) AS year, 
        SUM(orders.total_amt_usd) AS total_spent
FROM orders
GROUP BY DATE_PART('year', orders.occurred_at)
ORDER BY total_spent;

-- Which month did Parch & Posey have the greatest sales in terms of total dollars? Are all months evenly represented by the dataset?

-- Which year did Parch & Posey have the greatest sales in terms of the total number of orders? Are all years evenly represented by the dataset?

-- Which month did Parch & Posey have the greatest sales in terms of the total number of orders? Are all months evenly represented by the dataset?

-- In which month of which year did Walmart spend the most on gloss paper in terms of dollars?