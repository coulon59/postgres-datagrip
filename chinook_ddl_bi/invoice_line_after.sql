CREATE TABLE invoice_line
(
    created_at      timestamptz NOT NULL DEFAULT now(),
    updated_at      timestamptz NOT NULL DEFAULT now(),

    invoice_line_id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    invoice_id      integer NOT NULL,
    track_id        integer NOT NULL,
    quantity        integer NOT NULL,

    is_active       boolean NOT NULL DEFAULT true,

    unit_price      numeric(10,2) NOT NULL
);
