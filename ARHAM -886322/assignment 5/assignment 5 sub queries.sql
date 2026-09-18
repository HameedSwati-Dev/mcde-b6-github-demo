---SECTION 05---------
--------------------------SUB QUERIES---------------------------------------


---Task 29:  Find all products whose list price is above the overall average list price. Hint: Use a subquery in the WHERE clause with AVG().

SELECT *
FROM production.products
WHERE list_price >(
      SELECT AVG(list_price)
      FROM production.products
  );


---Task 30:  Find customers who have never placed an order.

SELECT *
FROM sales.customers as c
WHERE NOT EXISTS (
       SELECT *
       FROM sales.orders AS o
       WHERE o.customer_id = c.customer_id
       );
       

------Task 31:  List the most expensive product in each category.

SELECT *
FROM production.products as p1
WHERE list_price = (
     SELECT MAX(p2.list_price)
    FROM production.products as p2 
    WHERE p1.category_id=p2.category_id
    );

-----Task 32:  Find staff members who work in the store that generated the most revenue.
SELECT
    s.staff_id,
    s.first_name,
    s.last_name,
    s.store_id
FROM sales.staffs s
WHERE s.store_id = (
    SELECT TOP 1
        o.store_id
    FROM sales.orders o
   INNER JOIN sales.order_items oi
        ON o.order_id = oi.order_id
    GROUP BY o.store_id
    ORDER BY SUM(oi.quantity * oi.list_price * (1 - oi.discount)) DESC
);





---Task 33:  Find orders where the total order value exceeds 5000. Hint: Use a subquery to calculate order totals, then filter in the outer query.

SELECT *
FROM sales.orders
WHERE order_id IN (
    SELECT o.order_id
    FROM sales.orders o
  inner  JOIN sales.order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY o.order_id
    HAVING SUM(oi.quantity * oi.list_price) > 5000
);


----Task 34:  List products that have never been ordered by any customer.


SELECT *
FROM production.products AS p
WHERE NOT EXISTS (
    SELECT 1 
    FROM sales.order_items AS oi
    WHERE oi.product_id = p.product_id
    ) ;

----Task 35:  Find the customer who has spent the most money overall.

SELECT TOP 1
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(oi.quantity * oi.list_price) AS total_spent
FROM sales.customers c
INNER JOIN sales.orders o
    ON c.customer_id = o.customer_id
INNER JOIN sales.order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_spent DESC;
