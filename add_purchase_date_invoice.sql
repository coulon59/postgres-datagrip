ALTER TABLE invoice
    ADD COLUMN purchase_date DATE
        GENERATED ALWAYS AS (DATE("billing_postal_code"::int + "invoice_id")) STORED;