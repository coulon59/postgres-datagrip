CREATE TABLE media_type
(
    created_at      timestamptz NOT NULL DEFAULT now(),
    updated_at      timestamptz NOT NULL DEFAULT now(),

    media_type_id   integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    is_active       boolean NOT NULL DEFAULT true,

    name            varchar(120)
);
