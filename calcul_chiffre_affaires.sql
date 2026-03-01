-- Script SQL PostgreSQL pour calculer le chiffre d'affaires total par genre musical ou par pays
-- Base de données: Chinook
-- Auteur: Assistant SQL
-- Date: 2026-02-27

-- Gestion des transactions
BEGIN;
-- Rollback en cas d'erreur
-- COMMIT; -- Décommenter pour valider les changements

-- =================================================================
-- CALCUL DU CHIFFRE D'AFFAIRES PAR GENRE MUSICAL
-- =================================================================

-- Vue 1: Chiffre d'affaires total par genre musical
CREATE OR REPLACE VIEW ca_par_genre_musical AS
SELECT 
    g.name AS genre_musical,
    COUNT(DISTINCT c.customer_id) AS nombre_clients,
    COUNT(DISTINCT i.invoice_id) AS nombre_factures,
    COUNT(DISTINCT il.track_id) AS nombre_pistes_vendues,
    SUM(il.quantity) AS total_unites_vendues,
    ROUND(SUM(il.unit_price * il.quantity), 2) AS chiffre_affaires_total,
    ROUND(AVG(il.unit_price * il.quantity), 2) AS montant_moyen_ligne,
    ROUND(SUM(il.unit_price * il.quantity) * 100.0 / NULLIF((SELECT SUM(total) FROM invoice), 0), 2) AS pourcentage_ca_total
FROM 
    genre g
    INNER JOIN track t ON g.genre_id = t.genre_id
    INNER JOIN invoice_line il ON t.track_id = il.track_id
    INNER JOIN invoice i ON il.invoice_id = i.invoice_id
    INNER JOIN customer c ON i.customer_id = c.customer_id
GROUP BY 
    g.genre_id, g.name
ORDER BY 
    chiffre_affaires_total DESC;

-- =================================================================
-- CALCUL DU CHIFFRE D'AFFAIRES PAR PAYS
-- =================================================================

-- Vue 2: Chiffre d'affaires total par pays
CREATE OR REPLACE VIEW ca_par_pays AS
SELECT 
    c.country AS pays,
    COUNT(DISTINCT c.customer_id) AS nombre_clients,
    COUNT(DISTINCT i.invoice_id) AS nombre_factures,
    COUNT(DISTINCT il.track_id) AS nombre_pistes_vendues,
    SUM(il.quantity) AS total_unites_vendues,
    ROUND(SUM(il.unit_price * il.quantity), 2) AS chiffre_affaires_total,
    ROUND(AVG(il.unit_price * il.quantity), 2) AS montant_moyen_ligne,
    ROUND(SUM(il.unit_price * il.quantity) * 100.0 / NULLIF((SELECT SUM(total) FROM invoice), 0), 2) AS pourcentage_ca_total
FROM 
    customer c
    INNER JOIN invoice i ON c.customer_id = i.customer_id
    INNER JOIN invoice_line il ON i.invoice_id = il.invoice_id
    INNER JOIN track t ON il.track_id = t.track_id
GROUP BY 
    c.country
ORDER BY 
    chiffre_affaires_total DESC;

-- =================================================================
-- REQUÊTES DIRECTES (sans création de vues)
-- =================================================================

-- Requête 1: Chiffre d'affaires par genre musical (requête directe)
SELECT 
    g.name AS genre_musical,
    COUNT(DISTINCT c.customer_id) AS nombre_clients,
    COUNT(DISTINCT i.invoice_id) AS nombre_factures,
    COUNT(DISTINCT il.track_id) AS nombre_pistes_vendues,
    SUM(il.quantity) AS total_unites_vendues,
    ROUND(SUM(il.unit_price * il.quantity), 2) AS chiffre_affaires_total,
    ROUND(AVG(il.unit_price * il.quantity), 2) AS montant_moyen_ligne,
    ROUND(SUM(il.unit_price * il.quantity) * 100.0 / NULLIF((SELECT SUM(total) FROM invoice), 0), 2) AS pourcentage_ca_total
FROM 
    genre g
    INNER JOIN track t ON g.genre_id = t.genre_id
    INNER JOIN invoice_line il ON t.track_id = il.track_id
    INNER JOIN invoice i ON il.invoice_id = i.invoice_id
    INNER JOIN customer c ON i.customer_id = c.customer_id
GROUP BY 
    g.genre_id, g.name
ORDER BY 
    chiffre_affaires_total DESC;

-- Requête 2: Chiffre d'affaires par pays (requête directe)
SELECT 
    c.country AS pays,
    COUNT(DISTINCT c.customer_id) AS nombre_clients,
    COUNT(DISTINCT i.invoice_id) AS nombre_factures,
    COUNT(DISTINCT il.track_id) AS nombre_pistes_vendues,
    SUM(il.quantity) AS total_unites_vendues,
    ROUND(SUM(il.unit_price * il.quantity), 2) AS chiffre_affaires_total,
    ROUND(AVG(il.unit_price * il.quantity), 2) AS montant_moyen_ligne,
    ROUND(SUM(il.unit_price * il.quantity) * 100.0 / NULLIF((SELECT SUM(total) FROM invoice), 0), 2) AS pourcentage_ca_total
FROM 
    customer c
    INNER JOIN invoice i ON c.customer_id = i.customer_id
    INNER JOIN invoice_line il ON i.invoice_id = il.invoice_id
    INNER JOIN track t ON il.track_id = t.track_id
GROUP BY 
    c.country
ORDER BY 
    chiffre_affaires_total DESC;

-- =================================================================
-- ANALYSES AVANCÉES
-- =================================================================

-- Analyse combinée: Chiffre d'affaires par genre musical et pays
SELECT c.country                                                                                        AS pays,
       g.name                                                                                           AS genre_musical,
       COUNT(DISTINCT c.customer_id)                                                                    AS nombre_clients,
       COUNT(DISTINCT i.invoice_id)                                                                     AS nombre_factures,
       COUNT(DISTINCT il.track_id)                                                                      AS nombre_pistes_vendues,
       SUM(il.quantity)                                                                                 AS total_unites_vendues,
       ROUND(SUM(il.unit_price * il.quantity), 2)                                                       AS chiffre_affaires_total,
       ROUND(AVG(il.unit_price * il.quantity), 2)                                                       AS montant_moyen_ligne,
       ROUND(SUM(il.unit_price * il.quantity) * 100.0 / NULLIF((SELECT SUM(total) FROM invoice), 0),
             2)                                                                                         AS pourcentage_ca_total
FROM customer c
         INNER JOIN invoice i ON c.customer_id = i.customer_id
         INNER JOIN invoice_line il ON i.invoice_id = il.invoice_id
         INNER JOIN track t ON il.track_id = t.track_id
         INNER JOIN genre g ON t.genre_id = g.genre_id
GROUP BY c.country, g.genre_id, g.name
ORDER BY c.country, chiffre_affaires_total DESC;

-- Analyse temporelle: Chiffre d'affaires par genre musical et mois
SELECT 
    g.name AS genre_musical,
    DATE_TRUNC('month', i.invoice_date) AS mois,
    COUNT(DISTINCT c.customer_id) AS nombre_clients,
    COUNT(DISTINCT i.invoice_id) AS nombre_factures,
    COUNT(DISTINCT il.track_id) AS nombre_pistes_vendues,
    SUM(il.quantity) AS total_unites_vendues,
    ROUND(SUM(il.unit_price * il.quantity), 2) AS chiffre_affaires_total,
    ROUND(AVG(il.unit_price * il.quantity), 2) AS montant_moyen_ligne
FROM 
    genre g
    INNER JOIN track t ON g.genre_id = t.genre_id
    INNER JOIN invoice_line il ON t.track_id = il.track_id
    INNER JOIN invoice i ON il.invoice_id = i.invoice_id
    INNER JOIN customer c ON i.customer_id = c.customer_id
WHERE 
    i.invoice_date >= CURRENT_DATE - INTERVAL '12 months'
GROUP BY 
    g.genre_id, g.name, DATE_TRUNC('month', i.invoice_date)
ORDER BY 
    mois DESC, chiffre_affaires_total DESC;

-- Analyse temporelle: Chiffre d'affaires par pays et mois
SELECT 
    c.country AS pays,
    DATE_TRUNC('month', i.invoice_date) AS mois,
    COUNT(DISTINCT c.customer_id) AS nombre_clients,
    COUNT(DISTINCT i.invoice_id) AS nombre_factures,
    COUNT(DISTINCT il.track_id) AS nombre_pistes_vendues,
    SUM(il.quantity) AS total_unites_vendues,
    ROUND(SUM(il.unit_price * il.quantity), 2) AS chiffre_affaires_total,
    ROUND(AVG(il.unit_price * il.quantity), 2) AS montant_moyen_ligne
FROM 
    customer c
    INNER JOIN invoice i ON c.customer_id = i.customer_id
    INNER JOIN invoice_line il ON i.invoice_id = il.invoice_id
    INNER JOIN track t ON il.track_id = t.track_id
WHERE 
    i.invoice_date >= CURRENT_DATE - INTERVAL '12 months'
GROUP BY 
    c.country, DATE_TRUNC('month', i.invoice_date)
ORDER BY 
    mois DESC, chiffre_affaires_total DESC;

-- =================================================================
-- UTILISATION DES VUES CRÉÉES
-- =================================================================

-- Pour utiliser les vues créées:
-- SELECT * FROM ca_par_genre_musical;
-- SELECT * FROM ca_par_pays;

-- Exemples de requêtes sur les vues:
-- Top 5 des pays par chiffre d'affaires
-- SELECT * FROM ca_par_pays LIMIT 5;

-- Pays avec plus de 1000€ de chiffre d'affaires
-- SELECT * FROM ca_par_pays WHERE chiffre_affaires_total > 1000;

-- Top 10 des genres musicaux par chiffre d'affaires
-- SELECT * FROM ca_par_genre_musical LIMIT 10;

-- =================================================================
-- NOTES D'ADAPTATION POUR LA BASE DE DONNÉES CHINOOK
-- =================================================================

/*
Structure de la base de données Chinook utilisée:

Tables principales:
- customer: informations sur les clients (country, customer_id, etc.)
- invoice: factures (invoice_id, customer_id, invoice_date, total)
- invoice_line: lignes de facture (invoice_id, track_id, unit_price, quantity)
- track: pistes musicales (track_id, genre_id, name, unit_price)
- genre: genres musicaux (genre_id, name)

Relations utilisées:
customer -> invoice -> invoice_line -> track -> genre

Le script calcule le chiffre d'affaires en se basant sur:
- invoice_line.unit_price * invoice_line.quantity pour chaque ligne de facture
- Agrégation par genre musical ou par pays
- Inclusion de métriques supplémentaires: nombre de clients, factures, pistes vendues

Indicateurs calculés:
- nombre_clients: nombre de clients uniques
- nombre_factures: nombre de factures uniques  
- nombre_pistes_vendues: nombre de pistes différentes vendues
- total_unites_vendues: somme des quantités vendues
- chiffre_affaires_total: somme des (unit_price * quantity)
- montant_moyen_ligne: montant moyen par ligne de facture
- pourcentage_ca_total: pourcentage du chiffre d'affaires total

-- Pour des analyses plus spécifiques, vous pouvez:
1. Ajouter des filtres WHERE sur les dates
2. Inclure d'autres dimensions (artistes, albums, etc.)
3. Ajouter des conditions sur les montants minimums
4. Créer des vues matérialisées pour de meilleures performances

-- Validation des changements (décommenter pour exécuter)
-- COMMIT;

-- En cas d'erreur, rollback automatique
-- ROLLBACK;
*/
