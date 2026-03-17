SELECT
    relname AS nom_table,
    n_live_tup AS lignes_vivantes,
    n_dead_tup AS lignes_mortes,
    ROUND((n_dead_tup::numeric / NULLIF(n_live_tup + n_dead_tup, 0)) * 100, 2) AS pourcentage_mortes,
    last_autovacuum AS dernier_autovacuum,
    last_vacuum AS dernier_vacuum_manuel
FROM
    pg_stat_user_tables
ORDER BY
    pourcentage_mortes DESC NULLS LAST;

ANALYSE invoice_line;
ANALYSE artist;
ANALYSE customer;
ANALYSE invoice;
ANALYSE album;
ANALYSE media_type;
ANALYSE employee;
ANALYSE genre;
ANALYSE playlist_track;
ANALYSE playlist;
ANALYSE track;
