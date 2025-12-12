SELECT c.customer_id,
       c.customer_name,
       SUM(o.order_amount) AS total_spent
FROM customer c
JOIN orders o
  ON c.customer_id = o.customer_id
WHERE o.order_date >= DATE '2023-01-01'
GROUP BY c.customer_id, c.customer_name
HAVING SUM(o.order_amount) > 1000
ORDER BY total_spent DESC;