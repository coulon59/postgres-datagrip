-- find lock
SELECT pid, state, query
FROM pg_stat_activity
WHERE wait_event_type = 'Lock';

-- find long transaction
SELECT pid, state, xact_start, query
FROM pg_stat_activity
WHERE state IN ('idle in transaction', 'active')
ORDER BY xact_start;

-- find table stats
SELECT n_live_tup, n_dead_tup, last_vacuum, last_analyze
FROM pg_stat_user_tables
WHERE relname = 'invoice';

-- index fantomes
SELECT
    relname AS table_name,
    indexrelname AS index_name,
    idx_scan AS nb_scans,     -- Nombre de fois où l'index a été utilisé
    idx_tup_read AS tuples_lus,
    idx_tup_fetch AS tuples_extraits,
    pg_size_pretty(pg_relation_size(indexrelid)) AS taille_index
FROM
    pg_stat_user_indexes
WHERE
    schemaname = 'public'
  AND relname = 'invoice' -- Tu peux enlever cette ligne pour voir toute la base
ORDER BY
    idx_scan ASC,
    pg_relation_size(indexrelid) DESC;

-- stop processus
SELECT pg_terminate_backend(14210)
