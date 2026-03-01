SELECT a.title, ar.name AS artist_name
FROM artist ar
LEFT JOIN album a ON a.artist_id = ar.artist_id
where a.artist_id = 50;
