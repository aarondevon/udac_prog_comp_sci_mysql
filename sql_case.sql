/* 
Write a query to display for each order, the account ID, the total amount of the order,
and the level of the order - ‘Large’ or ’Small’ - depending on if the order is $3000 or
more, or smaller than $3000. 
*/
SELECT account_id, total_amt_usd,
CASE
    WHEN total_amt_usd >= 3000 THEN 'Large'
    ELSE 'Small'
END AS level
FROM orders;

/*
Write a query to display the number of orders in each of three categories, based on the
total number of items in each order. The three categories are: 'At Least 2000', 'Between
1000 and 2000' and 'Less than 1000'.
*/
SELECT CASE
    WHEN total >= 2000 THEN 'At Least 2000'
    WHEN total BETWEEN 1000 AND 2000 THEN 'Between 1000 and 2000'
    ELSE 'Less than 1000'
END AS level,
COUNT(*) AS order_count
FROM orders
GROUP BY 1;

/* 
We would like to understand 3 different levels of customers based on the amount associated
with their purchases. The top-level includes anyone with a Lifetime Value (total sales of all orders)
greater than 200,000 usd. The second level is between 200,000 and 100,000 usd. The lowest level
is anyone under 100,000 usd. Provide a table that includes the level associated with each account.
You should provide the account name, the total sales of all orders for the customer, and the level.
Order with the top spending customers listed first.
*/
SELECT accounts.name, SUM(orders.total_amt_usd) AS total_spent,
CASE
    WHEN SUM(orders.total_amt_usd) > 200000 THEN 'top'
    WHEN SUM(orders.total_amt_usd) BETWEEN 100000 AND 200000 THEN 'middle'
    ELSE 'low'
END AS customer_level
FROM accounts
    JOIN orders
    ON accounts.id = orders.account_id
GROUP BY accounts.name
ORDER BY 2 DESC;

/* 
We would now like to perform a similar calculation to the first, but we want to obtain the total amount
spent by customers only in 2016 and 2017. Keep the same levels as in the previous question. Order with the
top spending customers listed first.
*/
SELECT orders.account_id, accounts.name, DATE_PART('year' , orders.occurred_at) AS year, SUM(total_amt_usd) AS total_spent,
CASE
    WHEN SUM(orders.total_amt_usd) > 200000 THEN 'top'
    WHEN SUM(orders.total_amt_usd) BETWEEN 100000 AND 200000 THEN 'middle'
    ELSE 'low'
END AS customer_level
FROM orders
    JOIN accounts
    ON orders.account_id = accounts.id
GROUP BY 1, 2, 3
HAVING DATE_PART('year', orders.occurred_at) BETWEEN 2016 AND 2017
ORDER BY 4 DESC;

/*
We would like to identify top-performing sales reps, which are sales reps associated with more than 200 orders.
Create a table with the sales rep name, the total number of orders, and a column with top or not depending on if
they have more than 200 orders. Place the top salespeople first in your final table.
*/
SELECT sales_reps.name, COUNT(*) AS order_total,
CASE
    WHEN COUNT(*) > 200 THEN 'Top'
    ELSE 'Not'
END AS top_performing
FROM sales_reps
    JOIN accounts
    ON sales_reps.id = accounts.sales_rep_id
    JOIN orders
    ON accounts.id = orders.account_id
GROUP BY sales_reps.name
ORDER BY 2 DESC;

/*
The previous didn't account for the middle, nor the dollar amount associated with the sales. Management decides
they want to see these characteristics represented as well. We would like to identify top-performing sales reps,
which are sales reps associated with more than 200 orders or more than 750000 in total sales. The middle group
has any rep with more than 150 orders or 500000 in sales. Create a table with the sales rep name, the total
number of orders, total sales across all orders, and a column with top, middle, or low depending on these criteria. 
Place the top salespeople based on the dollar amount of sales first in your final table. You might see a few upset 
salespeople by this criteria!
*/
SELECT sales_reps.name, COUNT(*) AS total_orders, SUM(orders.total_amt_usd) AS total_amt_usd,
CASE
    WHEN COUNT(*) > 200 OR SUM(orders.total_amt_usd) > 750000 THEN 'Top'
    WHEN COUNT(*) > 150 OR SUM(orders.total_amt_usd) > 500000 THEN 'Middle'
    ELSE 'Low'
    END AS top_performing
FROM orders
    JOIN accounts
    ON orders.account_id = accounts.id
    JOIN sales_reps
    ON accounts.sales_rep_id = sales_reps.id
GROUP BY sales_reps.name
ORDER BY 3 DESC;
