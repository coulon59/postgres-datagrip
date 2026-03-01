-- Requête pour calculer la durée totale des morceaux de musique par genre
-- Base de données: Chinook
-- Auteur: Assistant SQL
-- Date: 2026-02-27

-- =================================================================
-- DURÉE TOTALE DES MORCEAUX PAR GENRE MUSICAL
-- =================================================================

-- Requête principale: Durée totale par genre
SELECT 
    g.name AS genre_musical,
    COUNT(DISTINCT t.track_id) AS nombre_morceaux,
    COUNT(DISTINCT t.album_id) AS nombre_albums,
    SUM(t.milliseconds) AS duree_totale_millisecondes,
    ROUND(SUM(t.milliseconds) / 1000.0, 2) AS duree_totale_secondes,
    ROUND(SUM(t.milliseconds) / 60000.0, 2) AS duree_totale_minutes,
    ROUND(SUM(t.milliseconds) / 3600000.0, 2) AS duree_totale_heures,
    ROUND(AVG(t.milliseconds) / 1000.0, 2) AS duree_moyenne_secondes,
    ROUND(AVG(t.milliseconds) / 60000.0, 2) AS duree_moyenne_minutes,
    MIN(t.milliseconds) / 1000.0 AS duree_min_secondes,
    MAX(t.milliseconds) / 1000.0 AS duree_max_secondes,
    ROUND(SUM(t.milliseconds) * 100.0 / (SELECT SUM(milliseconds) FROM track), 2) AS pourcentage_duree_totale
FROM 
    genre g
    INNER JOIN track t ON g.genre_id = t.genre_id
GROUP BY 
    g.genre_id, g.name
ORDER BY 
    duree_totale_minutes DESC;

-- =================================================================
-- VUE POUR RÉUTILISATION
-- =================================================================

-- Créer une vue pour réutiliser facilement
CREATE OR REPLACE VIEW duree_totale_par_genre AS
SELECT 
    g.name AS genre_musical,
    COUNT(DISTINCT t.track_id) AS nombre_morceaux,
    COUNT(DISTINCT t.album_id) AS nombre_albums,
    SUM(t.milliseconds) AS duree_totale_millisecondes,
    ROUND(SUM(t.milliseconds) / 1000.0, 2) AS duree_totale_secondes,
    ROUND(SUM(t.milliseconds) / 60000.0, 2) AS duree_totale_minutes,
    ROUND(SUM(t.milliseconds) / 3600000.0, 2) AS duree_totale_heures,
    ROUND(AVG(t.milliseconds) / 1000.0, 2) AS duree_moyenne_secondes,
    ROUND(AVG(t.milliseconds) / 60000.0, 2) AS duree_moyenne_minutes,
    MIN(t.milliseconds) / 1000.0 AS duree_min_secondes,
    MAX(t.milliseconds) / 1000.0 AS duree_max_secondes,
    ROUND(SUM(t.milliseconds) * 100.0 / NULLIF((SELECT SUM(milliseconds) FROM track), 0), 2) AS pourcentage_duree_totale
FROM 
    genre g
    INNER JOIN track t ON g.genre_id = t.genre_id
GROUP BY 
    g.genre_id, g.name
ORDER BY 
    duree_totale_minutes DESC;

-- =================================================================
-- ANALYSES COMPLÉMENTAIRES
-- =================================================================

-- Analyse avec formatage de temps lisible (HH:MM:SS)
SELECT 
    g.name AS genre_musical,
    COUNT(DISTINCT t.track_id) AS nombre_morceaux,
    TO_CHAR(
        (SUM(t.milliseconds) || ' millisecond')::interval, 
        'HH24:MI:SS'
    ) AS duree_totale_formattee,
    TO_CHAR(
        (AVG(t.milliseconds) || ' millisecond')::interval, 
        'MI:SS'
    ) AS duree_moyenne_formattee
FROM 
    genre g
    INNER JOIN track t ON g.genre_id = t.genre_id
GROUP BY 
    g.genre_id, g.name
ORDER BY 
    SUM(t.milliseconds) DESC;

-- Analyse par genre avec détails d'artistes
SELECT 
    g.name AS genre_musical,
    COUNT(DISTINCT a.artist_id) AS nombre_artistes,
    COUNT(DISTINCT t.track_id) AS nombre_morceaux,
    COUNT(DISTINCT t.album_id) AS nombre_albums,
    ROUND(SUM(t.milliseconds) / 60000.0, 2) AS duree_totale_minutes,
    ROUND(AVG(t.milliseconds) / 60000.0, 2) AS duree_moyenne_minutes
FROM 
    genre g
    INNER JOIN track t ON g.genre_id = t.genre_id
    INNER JOIN album al ON t.album_id = al.album_id
    INNER JOIN artist a ON al.artist_id = a.artist_id
GROUP BY 
    g.genre_id, g.name
ORDER BY 
    duree_totale_minutes DESC;

-- Top 10 des morceaux les plus longs par genre
SELECT 
    g.name AS genre_musical,
    t.name AS nom_morceau,
    a.name AS artiste,
    al.title AS album,
    ROUND(t.milliseconds / 60000.0, 2) AS duree_minutes
FROM 
    genre g
    INNER JOIN track t ON g.genre_id = t.genre_id
    INNER JOIN album al ON t.album_id = al.album_id
    INNER JOIN artist a ON al.artist_id = a.artist_id
ORDER BY 
    t.milliseconds DESC
LIMIT 10;

-- =================================================================
-- UTILISATION DE LA VUE CRÉÉE
-- =================================================================

-- Pour utiliser la vue:
-- SELECT * FROM duree_totale_par_genre;

-- Exemples de requêtes sur la vue:
-- Top 5 des genres par durée totale
-- SELECT genre_musical, duree_totale_minutes FROM duree_totale_par_genre LIMIT 5;

-- Genres avec plus de 60 minutes de musique
-- SELECT * FROM duree_totale_par_genre WHERE duree_totale_minutes > 60;

-- =================================================================
-- NOTES TECHNIQUES
-- =================================================================

/*
Structure utilisée:
- genre: genres musicaux (genre_id, name)
- track: morceaux (track_id, name, album_id, genre_id, milliseconds)
- album: albums (album_id, title, artist_id)
- artist: artistes (artist_id, name)

Conversions de temps:
- milliseconds → secondes: / 1000
- milliseconds → minutes: / 60000
- milliseconds → heures: / 3600000

Formatage PostgreSQL:
- TO_CHAR(interval, 'HH24:MI:SS') pour format HH:MM:SS
- TO_CHAR(interval, 'MI:SS') pour format MM:SS

Pour des analyses plus avancées:
1. Ajouter des filtres sur les artistes ou albums
2. Inclure les statistiques de ventes
3. Créer des vues matérialisées pour performances
4. Ajouter des analyses temporelles (par décennie, etc.)
*/
