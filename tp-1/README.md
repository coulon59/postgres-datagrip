# TP-1 : Optimisation des requêtes PostgreSQL sur la base Chinook

Ce dossier contient un mini TP pour pratiquer l’optimisation de requêtes sur la base **Chinook** dans PostgreSQL.

## Prérequis

- Base de données Chinook créée dans PostgreSQL (via `chinook.ddl`).
- Client SQL (DataGrip, psql, etc.) connecté au bon schéma.

## Contenu des fichiers

- **01_fk_and_indexes.sql**  
  Création des **clés étrangères** et des **index** associés (sur `invoice.customer_id`, `invoice_line.invoice_id`, `invoice_line.track_id`, `track.album_id`, `track.genre_id`).  
  Objectif : permettre au planificateur d’utiliser des index appropriés sur les jointures.

- **02_analyze.sql**  
  Commandes `ANALYZE` et `VACUUM ANALYZE` pour mettre à jour les **statistiques** de PostgreSQL, essentielles pour de bons plans d’exécution.

- **03_distinct_vs_exists.sql**  
  Exemples de réécriture de requêtes pour **remplacer `DISTINCT` par `EXISTS`** lorsque l’on ne veut que tester l’existence de lignes liées (clients ayant au moins une facture, clients ayant acheté un genre donné, etc.).

- **04_joins_optimization.sql**  
  Exemples d’**INNER JOIN**, **LEFT JOIN** et **CROSS JOIN**, avec des cas concrets sur Chinook (total dépensé par client, clients sans facture, produit cartésien contrôlé).

- **05_explain_plan.sql**  
  Exemples d’utilisation de `EXPLAIN`, `EXPLAIN ANALYZE` et `EXPLAIN (ANALYZE, BUFFERS)` sur une requête typique (total dépensé par client).

## Comment appliquer les FK et index

1. Ouvrir `01_fk_and_indexes.sql` dans DataGrip.  
2. Vérifier que vous êtes bien connecté à la base où Chinook est chargé.  
3. Exécuter le script (ou partie par partie).  
4. Vérifier les index avec :
   ```sql
   \d invoice
   \d invoice_line
   \d track
   ```
   (ou l’équivalent dans l’UI de DataGrip : onglet **Database** → clic droit sur la table → **Jump to DDL** / **Properties** → Indexes).

## Comment lancer ANALYZE

1. Ouvrir `02_analyze.sql`.  
2. Exécuter d’abord `ANALYZE;` ou les `ANALYZE` ciblés.  
3. Après des gros changements de données, exécuter `VACUUM ANALYZE` sur les tables concernées.  
4. Refaire ensuite un `EXPLAIN ANALYZE` sur vos requêtes pour voir si le plan a changé.

## Remplacer DISTINCT par EXISTS

1. Ouvrir `03_distinct_vs_exists.sql`.  
2. Lancer les versions **`DISTINCT`** puis les versions **`EXISTS`**.  
3. Comparer les plans :
   ```sql
   EXPLAIN ANALYZE
   -- coller ici la requête DISTINCT
   ```
   puis :
   ```sql
   EXPLAIN ANALYZE
   -- coller ici la requête avec EXISTS
   ```
4. Observer :
   - les opérations de type **HashAggregate** ou **Sort** pour gérer le DISTINCT,  
   - la différence de coût/temps,  
   - le fait que `EXISTS` peut éviter un tri global.

## Optimiser les JOIN

1. Ouvrir `04_joins_optimization.sql`.  
2. Tester les exemples :
   - INNER JOIN avec filtres dans le `WHERE` les plus sélectifs possibles,  
   - LEFT JOIN pour conserver les « côtés gauche » sans match,  
   - CROSS JOIN pour des cas pédagogiques (produits cartésiens contrôlés).
3. Utiliser `EXPLAIN (ANALYZE, BUFFERS)` sur chaque requête pour voir :
   - si les index sont utilisés (Index Scan, Bitmap Index Scan),  
   - les coûts estimés vs temps réel,  
   - le nombre de lignes traitées.

## Utiliser EXPLAIN / EXPLAIN ANALYZE

1. Ouvrir `05_explain_plan.sql`.  
2. Exécuter les trois variantes :
   - `EXPLAIN` simple (plan sans exécution),  
   - `EXPLAIN ANALYZE` (plan + exécution réelle),  
   - `EXPLAIN (ANALYZE, BUFFERS)` pour voir aussi les lectures disque/mémoire.
3. Dans DataGrip, vous pouvez :
   - soit exécuter directement les commandes `EXPLAIN ...`,  
   - soit utiliser la vue graphique de plan (bouton **Explain Plan**).

## Pistes de travail supplémentaires

- Adapter les requêtes existantes du projet (par ex. `ca_par_genre_musical.sql`) en utilisant :
  - des CTE (`WITH`) pour factoriser des sous-requêtes,  
  - des `EXISTS` à la place de `DISTINCT` lorsque l’on teste seulement la présence de lignes,  
  - des index ciblés sur les colonnes les plus utilisées en jointure ou en filtre.
- Comparer systématiquement les plans avant/après modification avec `EXPLAIN ANALYZE`.
