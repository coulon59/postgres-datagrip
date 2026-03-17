-- Création / vérification des clés étrangères et index pour Chinook

-- Exemple : assurer la FK Invoice.customer_id -> Customer.customer_id
ALTER TABLE IF EXISTS invoice
    ADD CONSTRAINT IF NOT EXISTS fk_invoice_customer
        FOREIGN KEY (customer_id) REFERENCES customer(customer_id);

-- Index sur la clé étrangère pour accélérer les jointures Customer -> Invoice
CREATE INDEX IF NOT EXISTS idx_invoice_customer_id
    ON invoice(customer_id);

-- Exemple : FK InvoiceLine.invoice_id -> Invoice.invoice_id
ALTER TABLE IF EXISTS invoice_line
    ADD CONSTRAINT IF NOT EXISTS fk_invoiceline_invoice
        FOREIGN KEY (invoice_id) REFERENCES invoice(invoice_id);

CREATE INDEX IF NOT EXISTS idx_invoiceline_invoice_id
    ON invoice_line(invoice_id);

-- Exemple : FK InvoiceLine.track_id -> Track.track_id
ALTER TABLE IF EXISTS invoice_line
    ADD CONSTRAINT IF NOT EXISTS fk_invoiceline_track
        FOREIGN KEY (track_id) REFERENCES track(track_id);

CREATE INDEX IF NOT EXISTS idx_invoiceline_track_id
    ON invoice_line(track_id);

-- Exemple : FK Track.album_id -> Album.album_id
ALTER TABLE IF EXISTS track
    ADD CONSTRAINT IF NOT EXISTS fk_track_album
        FOREIGN KEY (album_id) REFERENCES album(album_id);

CREATE INDEX IF NOT EXISTS idx_track_album_id
    ON track(album_id);

-- Exemple : FK Track.genre_id -> Genre.genre_id
ALTER TABLE IF EXISTS track
    ADD CONSTRAINT IF NOT EXISTS fk_track_genre
        FOREIGN KEY (genre_id) REFERENCES genre(genre_id);

CREATE INDEX IF NOT EXISTS idx_track_genre_id
    ON track(genre_id);
