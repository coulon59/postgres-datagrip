#  tp-2 Fondations EXPLAIN et types d'index
##  Lire un plan d'exécution dans DataGrip

EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT t.TrackId, t.Name, t.UnitPrice, g.Name AS Genre
FROM Track t
JOIN Genre g ON g.GenreId = t.GenreId
WHERE t.UnitPrice > 0.99
ORDER BY t.UnitPrice DESC;
