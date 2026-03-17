create table public.artist
(
    artist_id integer generated always as identity
        primary key,
    name      varchar(120)
);

alter table public.artist
    owner to chinook;

create table public.album
(
    album_id  integer generated always as identity
        primary key,
    title     varchar(160) not null,
    artist_id integer      not null
        references public.artist
);

alter table public.album
    owner to chinook;

create index album_artist_id_idx
    on public.album (artist_id);

create table public.employee
(
    employee_id integer generated always as identity
        primary key,
    last_name   varchar(20) not null,
    first_name  varchar(20) not null,
    title       varchar(30),
    reports_to  integer
        references public.employee,
    birth_date  timestamp,
    hire_date   timestamp,
    address     varchar(70),
    city        varchar(40),
    state       varchar(40),
    country     varchar(40),
    postal_code varchar(10),
    phone       varchar(24),
    fax         varchar(24),
    email       varchar(60)
);

alter table public.employee
    owner to chinook;

create table public.customer
(
    customer_id    integer generated always as identity
        primary key,
    first_name     varchar(40) not null,
    last_name      varchar(20) not null,
    company        varchar(80),
    address        varchar(70),
    city           varchar(40),
    state          varchar(40),
    country        varchar(40),
    postal_code    varchar(10),
    phone          varchar(24),
    fax            varchar(24),
    email          varchar(60) not null,
    support_rep_id integer
        references public.employee
);

alter table public.customer
    owner to chinook;

create index customer_support_rep_id_idx
    on public.customer (support_rep_id);

create index employee_reports_to_idx
    on public.employee (reports_to);

create table public.genre
(
    genre_id integer generated always as identity
        primary key,
    name     varchar(120)
);

alter table public.genre
    owner to chinook;

create table public.invoice
(
    invoice_id          integer generated always as identity
        primary key,
    customer_id         integer        not null
        references public.customer,
    invoice_date        timestamp      not null,
    billing_address     varchar(70),
    billing_city        varchar(40),
    billing_state       varchar(40),
    billing_country     varchar(40),
    billing_postal_code varchar(10),
    total               numeric(10, 2) not null,
    purchase_date       date
);

alter table public.invoice
    owner to chinook;

create index invoice_customer_id_idx
    on public.invoice (customer_id);

create table public.media_type
(
    media_type_id integer generated always as identity
        primary key,
    name          varchar(120)
);

alter table public.media_type
    owner to chinook;

create table public.playlist
(
    playlist_id integer generated always as identity
        primary key,
    name        varchar(120)
);

alter table public.playlist
    owner to chinook;

create table public.track
(
    track_id      integer generated always as identity
        primary key,
    name          varchar(200)   not null,
    album_id      integer
        references public.album,
    media_type_id integer        not null
        references public.media_type,
    genre_id      integer
        references public.genre,
    composer      varchar(220),
    milliseconds  integer        not null,
    bytes         integer,
    unit_price    numeric(10, 2) not null
);

alter table public.track
    owner to chinook;

create table public.invoice_line
(
    invoice_line_id integer generated always as identity
        primary key,
    invoice_id      integer        not null
        references public.invoice,
    track_id        integer        not null
        references public.track,
    unit_price      numeric(10, 2) not null,
    quantity        integer        not null
);

alter table public.invoice_line
    owner to chinook;

create index invoice_line_invoice_id_idx
    on public.invoice_line (invoice_id);

create index invoice_line_track_id_idx
    on public.invoice_line (track_id);

create table public.playlist_track
(
    playlist_id integer not null
        references public.playlist,
    track_id    integer not null
        references public.track,
    primary key (playlist_id, track_id)
);

alter table public.playlist_track
    owner to chinook;

create index playlist_track_playlist_id_idx
    on public.playlist_track (playlist_id);

create index playlist_track_track_id_idx
    on public.playlist_track (track_id);

create index track_album_id_idx
    on public.track (album_id);

create index track_genre_id_idx
    on public.track (genre_id);

create index track_media_type_id_idx
    on public.track (media_type_id);

