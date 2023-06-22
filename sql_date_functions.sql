-- Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. Do you notice any trends in the yearly sales totals?
SELECT DATE_PART('year', orders.occurred_at) AS year, 
        SUM(orders.total_amt_usd) AS total_spent
FROM orders
GROUP BY DATE_PART('year', orders.occurred_at)
ORDER BY total_spent DESC;

-- Which month did Parch & Posey have the greatest sales in terms of total dollars? Are all months evenly represented by the dataset?
SELECT DATE_PART('month', occurred_at) AS month, SUM(total_amt_usd) AS total_spent
FROM orders
-- for this scenario 2013 did not have many sales, and they year 2017 just started
WHERE occured_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC;

-- Which year did Parch & Posey have the greatest sales in terms of the total number of orders? Are all years evenly represented by the dataset?
SELECT DATE_PART('year', occurred_at) AS order_year,  COUNT(*) total_sales
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

-- Which month did Parch & Posey have the greatest sales in terms of the total number of orders? Are all months evenly represented by the dataset?
SELECT DATE_PART('month', occurred_at) AS order_month, COUNT(*) AS total_orders
FROM orders
WHERE DATE_PART('year', occurred_at) BETWEEN 2014 AND 2016
GROUP BY 1
ORDER BY 2 DESC;

-- In which month of which year did Walmart spend the most on gloss paper in terms of dollars?
SELECT DATE_PART('year', occurred_at) AS order_year, DATE_PART('month', occurred_at) AS order_month, SUM(gloss_amt_usd) AS total_orders
FROM orders
    JOIN accounts
    ON orders.account_id = accounts.id
    AND accounts.name = 'Walmart'
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 1;