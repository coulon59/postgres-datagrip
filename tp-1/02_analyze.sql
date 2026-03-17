-- ANALYZE pour mettre à jour les statistiques de la base Chinook

-- Mettre à jour les stats de toutes les tables du schéma public
ANALYZE;

-- Exemple : n’ANALYZE qu’un sous-ensemble de tables
ANALYZE customer;
ANALYZE invoice;
ANALYZE invoice_line;
ANALYZE track;

-- Après des gros imports ou mises à jour, on peut utiliser VACUUM ANALYZE
VACUUM ANALYZE invoice;
VACUUM ANALYZE invoice_line;
