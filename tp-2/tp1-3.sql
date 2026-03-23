#TP 1.3 — Index composites et ordre des colonnes
Règle : colonne la plus sélective EN PREMIER
Cas : filtrer sur Country + State, trier par CustomerId

SELECT customer_id, Email, State
FROM Customer
WHERE Country = 'USA'
ORDER BY customer_id;

-- Mauvais ordre
CREATE INDEX idx_cust_bad ON Customer(Country, State, customer_id);
DROP INDEX idx_cust_bad;
-- Bon ordre pour une requête analytique typique et covering index
CREATE INDEX idx_cust_good ON Customer(Country, customer_id) INCLUDE (State, Email);

-- Index partiel : ne couvrir que les données pertinentes
SELECT customer_id, SUM(Total)
FROM Invoice
WHERE Total > 10.00
GROUP BY customer_id
ORDER BY 2 DESC;

-- Index partiel : ne couvrir que les données pertinentes
CREATE INDEX idx_invoice_highvalue ON Invoice(customer_id, Total)
    WHERE Total > 10.00;
-- Observer la taille réduite vs un index complet
SELECT pg_size_pretty(pg_relation_size('idx_invoice_highvalue'));