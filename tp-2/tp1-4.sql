-- TP 1.4 — GIN pour la recherche textuelle

SELECT track.track_id, Name, Composer
FROM track
WHERE Name ILIKE '%Symphonic%';

-- GIN avec trgm_ops
-- GIN : Generalized Inverted Index
-- trgm_ops : Textual similarity
CREATE INDEX idx_track_name_trgm ON Track USING GIN(name gin_trgm_ops);

-- Mesurer le gain (réinitialiser les stats buffers d'abord)
SELECT pg_stat_reset();


-- Exécuter plusieurs fois et observer dans pg_stat_user_indexes
SELECT indexrelname, idx_scan, idx_tup_read
FROM pg_stat_user_indexes
WHERE relname = 'track';
