SELECT t.track_id, t.Name, t.unit_price, g.Name AS Genre
FROM Track t
         JOIN Genre g ON g.genre_id = t.genre_id
WHERE t.unit_price > 0.99
ORDER BY t.unit_price DESC;

-- solution DDL
CREATE INDEX idx_track_unit_price_desc
    ON track (unit_price DESC);

-- in case of error in the query
-- ROLLBACK;