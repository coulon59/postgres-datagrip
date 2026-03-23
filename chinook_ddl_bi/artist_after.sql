CREATE TABLE artist
(
    created_at  timestamptz NOT NULL DEFAULT now(),
    updated_at  timestamptz NOT NULL DEFAULT now(),

    artist_id   integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    is_active   boolean NOT NULL DEFAULT true,

    name        varchar(120)
);
