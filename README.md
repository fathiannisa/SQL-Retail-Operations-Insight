# SQL-classicmodels-database

## Overview

Toko Cars is a store that sells miniature vehicle toys. The store owner has recently appointed a new manager and asked them to become familiar with the store's business processes. The store has a database that stores information related to its business operations. Help the manager understand it!

-- CASE 1: The manager wants to find out what product categories are sold in the store.
SELECT DISTINCT productline FROM products;

-- CASE 2: The manager wants to find out the 5 cheapest products that the store has purchased.
SELECT productname, productline, buyprice FROM products ORDER BY buyprice DESC LIMIT 5;

-- CASE 3: The manager wants to run a sales simulation. If the selling price of each product is set to be 10% lower than the MSRP (Manufacturer’s Suggested Retail Price), what would the projected total sales be for each product if all stock is sold out?
SELECT productname, productline, buyprice, msrp,
(msrp - 0.1 * msrp) AS salesprice,
quantityinstock * (msrp - 0.1 * msrp) AS totalsales
FROM products;

-- CASE 4: The manager wants to see the top 10 products that would generate the highest profit for the company if all stock is sold, assuming the selling price is set at 10% below the MSRP.
-- Note:
-- profit = revenue - product_cost
-- revenue = selling_price × stock_quantity
-- product_cost = purchase_price × stock_quantity
-- selling_price = MSRP - (10% × MSRP)
SELECT productname, quantityinstock, 
(msrp - 0.1 * msrp) AS saleprice,
(quantityinstock * (msrp - 0.1 * msrp) - (quantityinstock * buyprice)) AS profit
FROM products
ORDER BY profit DESC
LIMIT 10;

-- CASE 5: This time, the store manager wants to learn more about the customers. Specifically, they want to find out which customers are categorized as incorporated (Inc.) companies.
SELECT customername
FROM customers
WHERE customername LIKE '%Inc%'

-- CASE 6: In connection with the anniversary celebrations of New York City (NYC), Brickhaven, San Francisco, and Japan, the manager wants to run special programs in those locations. To do this, they want to find out which customers come from those cities/countries.
SELECT customername, city, country
FROM customers
WHERE country = 'Japan' OR city IN ('NYC', 'Brickhaven', 'San Francisco');

-- CASE 7: To boost sales, the manager plans to offer discounts to customers who still have available credit limits and come from the United States. Find the information of these customers.
SELECT customername, creditlimit, country
FROM customers
WHERE country = 'USA' AND creditlimit != 0
ORDER BY creditlimit
LIMIT 10;

-- CASE 8: As a form of appreciation, the store wants to give gifts to customers whose transaction amounts are among the top 10 highest transactions.
SELECT * 
FROM payments
ORDER BY amount DESC
LIMIT 10;
