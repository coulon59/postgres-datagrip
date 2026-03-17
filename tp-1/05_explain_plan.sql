-- Utilisation d’EXPLAIN et EXPLAIN ANALYZE sur une requête Chinook

-- 1) Plan logique sans exécution
EXPLAIN
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(il.unit_price * il.quantity) AS total_spent
FROM customer c
JOIN invoice i       ON i.customer_id = c.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;

-- 2) Plan + exécution réelle (coûts, temps, lignes, etc.)
EXPLAIN ANALYZE
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(il.unit_price * il.quantity) AS total_spent
FROM customer c
JOIN invoice i       ON i.customer_id = c.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;

-- 3) Plan détaillé avec buffers (très utile pour voir les I/O)
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(il.unit_price * il.quantity) AS total_spent
FROM customer c
JOIN invoice i       ON i.customer_id = c.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;
