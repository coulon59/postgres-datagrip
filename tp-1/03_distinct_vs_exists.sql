-- Comparaison DISTINCT vs EXISTS

-- 1) Version avec DISTINCT
SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM customer c
JOIN invoice i ON i.customer_id = c.customer_id;

-- 2) Version équivalente avec EXISTS (évite un tri/HashAggregate DISTINCT)
SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
WHERE EXISTS (
    SELECT 1
    FROM invoice i
    WHERE i.customer_id = c.customer_id
);

-- 3) Cas avec plusieurs jointures : clients qui ont acheté au moins une track d’un genre donné
-- Version DISTINCT
SELECT DISTINCT c.customer_id, c.first_name, c.last_name, g.name AS genre
FROM customer c
JOIN invoice i       ON i.customer_id = c.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t         ON t.track_id = il.track_id
JOIN genre g         ON g.genre_id = t.genre_id
WHERE g.name = 'Rock';

-- Version EXISTS
SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
WHERE EXISTS (
    SELECT 1
    FROM invoice i
    JOIN invoice_line il ON il.invoice_id = i.invoice_id
    JOIN track t         ON t.track_id = il.track_id
    JOIN genre g         ON g.genre_id = t.genre_id
    WHERE i.customer_id = c.customer_id
      AND g.name = 'Rock'
);
