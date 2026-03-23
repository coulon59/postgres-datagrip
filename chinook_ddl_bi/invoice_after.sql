CREATE TABLE invoice
(
    created_at          timestamptz NOT NULL DEFAULT now(),
    updated_at          timestamptz NOT NULL DEFAULT now(),

    invoice_id          integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id         integer NOT NULL,

    is_active           boolean NOT NULL DEFAULT true,

    invoice_date        timestamptz NOT NULL,
    billing_address     varchar(70),
    billing_city        varchar(40),
    billing_state       varchar(40),
    billing_country     varchar(40),
    billing_postal_code varchar(10),
    total               numeric(10,2) NOT NULL
);
