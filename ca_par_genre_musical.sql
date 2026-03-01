SELECT
    c.country AS pays,
    g.name AS genre_musical,
    COUNT(DISTINCT c.customer_id) AS nombre_clients,
    COUNT(DISTINCT i.invoice_id) AS nombre_factures,
    COUNT(DISTINCT il.track_id) AS nombre_pistes_vendues,
    SUM(il.quantity) AS total_unites_vendues,
    ROUND(SUM(il.unit_price * il.quantity), 2) AS chiffre_affaires_total,
    ROUND(AVG(il.unit_price * il.quantity), 2) AS montant_moyen_ligne,
    ROUND(SUM(il.unit_price * il.quantity) * 100.0 / (SELECT SUM(total) FROM invoice), 2) AS pourcentage_ca_total
FROM
    customer c
        INNER JOIN invoice i ON c.customer_id = i.customer_id
        INNER JOIN invoice_line il ON i.invoice_id = il.invoice_id
        INNER JOIN track t ON il.track_id = t.track_id
        INNER JOIN genre g ON t.genre_id = g.genre_id
GROUP BY
    c.country, g.genre_id, g.name
ORDER BY
    c.country, chiffre_affaires_total DESC;