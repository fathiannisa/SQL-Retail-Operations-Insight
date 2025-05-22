-- Aggregation Case
-- CASE 1: The store wants to review the completeness of its stock in the warehouse.
-- This is to determine whether the quantity of goods in stock is still sufficient. Try analyzing stock availability by calculating the total quantity currently available in the warehouse.
SELECT SUM(quantityinstock) AS totalstock
FROM products;

-- Aggregation, Grouping, Having
-- CASE 2: The store's warehouse operations team wants to review the variety of item types in the warehouse.
-- Item types with low variation will be supplemented. If the number of variations for a product type is less than 5, new variations will be added.
-- Therefore, find the number of item variations that are fewer than 5, grouped by the type of product being sold.
SELECT productline,
COUNT(DISTINCT productname) AS total_product_type
FROM products
GROUP BY productline
HAVING COUNT(DISTINCT productname) < 5;

-- Aggregation and Grouping with Limit
-- CASE 3: In the final stage of the restocking process, the store wants to compare the stock of each item with the average stock level.
-- This comparison will help identify which items are below average and should be restocked.
-- Therefore, compare the stock levels of all items with the average stock, and find the items that have quantities below the average.
SELECT productname, quantityinstock,
AVG(quantityinstock) AS average_stock
FROM products
GROUP BY productname, quantityinstock;
-- The result is not relevant because the average stock was calculated only once using a subquery, making it static and not dynamically attached to each row—limiting flexibility for comparisons, especially within groups.
-- Therefore, I used a window function to dynamically compare each product’s stock to the overall average, which is more efficient and flexible than a static subquery.
SELECT productname, productline, quantityinstock,
AVG(quantityinstock) OVER(PARTITION BY productline) AS average_stock
FROM products;
-- With window function, each row will show its own group's (productline) average next to it.

-- CASE 4: Analyzing the Relationship Between Price and Purchase Quantity
-- The store wants to understand whether the price of a product affects its purchase quantity.
-- Specifically, do higher prices lead to fewer purchases, and do lower prices result in more purchases?
-- To answer this, analyze the relationship between product price and the quantity purchased.
SELECT productcode, priceeach, quantityordered,
DENSE_RANK() OVER(ORDER BY priceeach) AS pricerank,
DENSE_RANK() OVER(ORDER BY quantityordered DESC) AS qtyrank
FROM orderdetails
ORDER BY qtyrank;

-- CASE 5: The store wants to see customer characteristics by comparing the purchase date with the next purchase and the purchase price. This is to answer how long it takes for a customer to make the next purchase and whether the next purchase has a higher or lower quantity. So, try to find the comparison between each purchase date and the next purchase along with the purchase price.
SELECT customernumber, paymentdate,
LEAD(paymentdate, 1) OVER(PARTITION BY customernumber ORDER BY paymentdate) AS nextpaymentdate
FROM payments;

-- CASE 6: Lastly, the store wants to see the N-th highest price in each miniature type, then compare it with all product types within each miniature type. So, try to find a comparison of the N-th highest price for each product type in each miniature type.
SELECT productname, productline, buyprice,
NTH_VALUE(productname, 4) OVER(PARTITION BY productline ORDER BY buyprice DESC
RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS fourth_most_expensive_product,
NTH_VALUE(buyprice, 4) OVER(PARTITION BY productline ORDER BY buyprice DESC
RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS fourth_most_expensive_price
FROM products;

