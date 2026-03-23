CREATE TABLE playlist_track
(
    created_at  timestamptz NOT NULL DEFAULT now(),
    updated_at  timestamptz NOT NULL DEFAULT now(),

    playlist_id integer NOT NULL,
    track_id    integer NOT NULL,

    is_active   boolean NOT NULL DEFAULT true,

    PRIMARY KEY (playlist_id, track_id)
);
