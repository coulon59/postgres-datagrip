CREATE TABLE customer
(
    created_at      timestamptz NOT NULL DEFAULT now(),
    updated_at      timestamptz NOT NULL DEFAULT now(),

    customer_id     integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    support_rep_id  integer,

    is_active       boolean NOT NULL DEFAULT true,

    first_name      varchar(40)  NOT NULL,
    last_name       varchar(20)  NOT NULL,
    company         varchar(80),
    address         varchar(70),
    city            varchar(40),
    state           varchar(40),
    country         varchar(40),
    postal_code     varchar(10),
    phone           varchar(24),
    fax             varchar(24),
    email           varchar(60)  NOT NULL
);
