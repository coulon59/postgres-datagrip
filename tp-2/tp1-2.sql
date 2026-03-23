SELECT DATE_TRUNC('month', purchase_date)::date AS mois,
       COUNT(*) AS nb_factures,
       SUM(Total) AS ca
FROM invoice
WHERE purchase_date >= '2019-01-01' AND purchase_date < '2020-01-01'
GROUP BY 1
ORDER BY 1;

-- B-tree classique sur date
CREATE INDEX idx_inv_date_btree ON Invoice(purchase_date);

-- BRIN : efficace quand les données sont physiquement triées par date
-- Block Range Index
CREATE INDEX idx_inv_date_brin ON Invoice USING BRIN(purchase_date);

-- comparer la taille des index
SELECT indexname,
       pg_size_pretty(pg_relation_size(indexname::regclass)) AS taille
FROM pg_indexes
WHERE tablename = 'invoice'
  AND indexname LIKE 'idx_inv_date%';
