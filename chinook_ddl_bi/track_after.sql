CREATE TABLE track
(
    created_at      timestamptz NOT NULL DEFAULT now(),
    updated_at      timestamptz NOT NULL DEFAULT now(),

    track_id        integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    album_id        integer,
    media_type_id   integer NOT NULL,
    genre_id        integer,
    milliseconds    integer NOT NULL,
    bytes           integer,

    is_active       boolean NOT NULL DEFAULT true,

    name            varchar(200) NOT NULL,
    composer        varchar(220),
    unit_price      numeric(10,2) NOT NULL
);
