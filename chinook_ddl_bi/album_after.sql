CREATE TABLE album
(
    -- Aligné : 8 octets
    created_at  timestamptz NOT NULL DEFAULT now(),
    updated_at  timestamptz NOT NULL DEFAULT now(),

    -- Aligné : 4 octets
    album_id    integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    artist_id   integer NOT NULL REFERENCES artist,

    -- Aligné : Booléen (1 octet, placé juste avant le texte pour minimiser le padding)
    is_active   boolean NOT NULL DEFAULT true,

    -- Variable : En fin de ligne
    title       varchar(160) NOT NULL
);