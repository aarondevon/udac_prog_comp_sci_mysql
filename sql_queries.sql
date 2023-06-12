-- Write a query to return the 10 earliest orders in the orders table. Include the id, occurred_at, and total_amt_usd.
SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at
LIMIT 10;


-- Write a query to return the top 5 orders in terms of the largest total_amt_usd. Include the id, account_id, and total_amt_usd.
SELECT id
, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 5;

-- Write a query to return the lowest 20 orders in terms of the smallest total_amt_usd. Include the id, account_id, and total_amt_usd.
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd
LIMIT 20;

-- Write a query that displays the order ID, account ID, and total dollar amount for all the orders, sorted first by the account ID (in ascending order), and then by the total dollar amount (in descending order).
SELECT id
, account_id, total_amt_usd
FROM orders
ORDER BY account_id, total_amt_usd DESC;

-- Now write a query that again displays order ID, account ID, and total dollar amount for each order, but this time sorted first by total dollar amount (in descending order), and then by account ID (in ascending order).
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC, account_id;

-- Compare the results of these two queries above. How are the results different when you switch the column you sort on first?
-- The first query sorts the order by account id from least to greatest, and then by amount from greatest to least. If there are multiple of the same account id those id's are grouped together and then ordered by the amount from greatest to least.
-- The second query it is first order by amount from greatest to least. If then there are multiple of the same amount the account ids would be order from least to greatest.

-- Write a query that:
-- Pulls the first 5 rows and all columns from the orders table that have a dollar amount of gloss_amt_usd greater than or equal to 1000.
SELECT *
FROM orders
WHERE gloss_amt_usd >= 1000
LIMIT 5;

-- Pulls the first 10 rows and all columns from the orders table that have a total_amt_usd less than 500.
SELECT *
FROM orders
WHERE total_amt_usd < 500
LIMIT 10;

-- Filter the accounts table to include the company name, website, and the primary point of contact (primary_poc) just for the Exxon Mobil company in the accounts table.
SELECT name, website, primary_poc
FROM accounts
WHERE name = 'Exxon Mobil';

-- Create a column that divides the standard_amt_usd by the standard_qty to find the unit price for standard paper for each order. Limit the results to the first 10 orders, and include the id and account_id fields.
SELECT id, account_id, standard_amt_usd / standard_qty AS unit_price
FROM orders
LIMIT
10;

-- Write a query that finds the percentage of revenue that comes from poster paper for each order. You will need to use only the columns that end with _usd. (Try to do this without using the total column.) Display the id and account_id fields also. NOTE - you will receive an error with the correct solution to this question. This occurs because at least one of the values in the data creates a division by zero in your formula. There are ways to better handle this. For now, you can just limit your calculations to the first 10 orders, as we did in question #1, and you'll avoid that set of data that causes the problem.
SELECT id, account_id, (poster_amt_usd / (standard_amt_usd + gloss_amt_usd + poster_amt_usd) * 100) AS poster_percent_sales
FROM orders
LIMIT
10;

-- Use the accounts table to find
-- All the companies whose names start with 'C'.
SELECT *
FROM accounts
WHERE name LIKE 'C%';

-- All companies whose names contain the string 'one' somewhere in the name.
SELECT *
FROM accounts
WHERE name LIKE '%one%';

-- All companies whose names end with 's'.
SELECT *
FROM accounts
WHERE name LIKE '%s';

-- Questions using IN operator
-- Use the accounts table to find the account name, primary_poc, and sales_rep_id for Walmart, Target, and Nordstrom.
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom');

-- Use the web_events table to find all information regarding individuals who were contacted via the channel of organic or adwords.
SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords');

-- Questions using the NOT operator
-- We can pull all of the rows that were excluded from the queries in the previous two concepts with our new operator.

-- Use the accounts table to find the account name, primary poc, and sales rep id for all stores except Walmart, Target, and Nordstrom.
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name NOT IN ('Walmart', 'Target', 'Nordstrom');

-- Use the web_events table to find all information regarding individuals who were contacted via any method except using organic or adwords methods.
SELECT *
FROM web_events
WHERE channel NOT IN ('organic', 'adwords');

-- Use the accounts table to find:

-- All the companies whose names do not start with 'C'.
SELECT *
FROM accounts
WHERE name NOT LIKE ('C%');

-- All companies whose names do not contain the string 'one' somewhere in the name.
SELECT *
FROM accounts
WHERE name NOT LIKE ('%one%');

-- All companies whose names do not end with 's'.
SELECT *
FROM accounts
WHERE name NOT LIKE ('%s');

