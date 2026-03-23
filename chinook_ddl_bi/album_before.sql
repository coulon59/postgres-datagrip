create table album
(
    album_id  integer generated always as identity
        primary key,
    title     varchar(160) not null,
    artist_id integer      not null
        references artist
);

alter table album
    owner to chinook;

create index album_artist_id_idx
    on album (artist_id);