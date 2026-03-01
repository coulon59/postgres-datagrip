-- auto-generated definition
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

-- auto-generated definition
create table artist
(
    artist_id integer generated always as identity
        primary key,
    name      varchar(120)
);

alter table artist
    owner to chinook;

-- auto-generated definition
create table customer
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
        references employee
);

alter table customer
    owner to chinook;

create index customer_support_rep_id_idx
    on customer (support_rep_id);

-- auto-generated definition
create table employee
(
    employee_id integer generated always as identity
        primary key,
    last_name   varchar(20) not null,
    first_name  varchar(20) not null,
    title       varchar(30),
    reports_to  integer
        references employee,
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

alter table employee
    owner to chinook;

create index employee_reports_to_idx
    on employee (reports_to);

-- auto-generated definition
create table genre
(
    genre_id integer generated always as identity
        primary key,
    name     varchar(120)
);

alter table genre
    owner to chinook;

-- auto-generated definition
create table invoice
(
    invoice_id          integer generated always as identity
        primary key,
    customer_id         integer        not null
        references customer,
    invoice_date        timestamp      not null,
    billing_address     varchar(70),
    billing_city        varchar(40),
    billing_state       varchar(40),
    billing_country     varchar(40),
    billing_postal_code varchar(10),
    total               numeric(10, 2) not null
);

alter table invoice
    owner to chinook;

create index invoice_customer_id_idx
    on invoice (customer_id);

-- auto-generated definition
create table invoice_line
(
    invoice_line_id integer generated always as identity
        primary key,
    invoice_id      integer        not null
        references invoice,
    track_id        integer        not null
        references track,
    unit_price      numeric(10, 2) not null,
    quantity        integer        not null
);

alter table invoice_line
    owner to chinook;

create index invoice_line_invoice_id_idx
    on invoice_line (invoice_id);

create index invoice_line_track_id_idx
    on invoice_line (track_id);

-- auto-generated definition
create table media_type
(
    media_type_id integer generated always as identity
        primary key,
    name          varchar(120)
);

alter table media_type
    owner to chinook;

-- auto-generated definition
create table playlist
(
    playlist_id integer generated always as identity
        primary key,
    name        varchar(120)
);

alter table playlist
    owner to chinook;

-- auto-generated definition
create table playlist_track
(
    playlist_id integer not null
        references playlist,
    track_id    integer not null
        references track,
    primary key (playlist_id, track_id)
);

alter table playlist_track
    owner to chinook;

create index playlist_track_playlist_id_idx
    on playlist_track (playlist_id);

create index playlist_track_track_id_idx
    on playlist_track (track_id);

-- auto-generated definition
create table track
(
    track_id      integer generated always as identity
        primary key,
    name          varchar(200)   not null,
    album_id      integer
        references album,
    media_type_id integer        not null
        references media_type,
    genre_id      integer
        references genre,
    composer      varchar(220),
    milliseconds  integer        not null,
    bytes         integer,
    unit_price    numeric(10, 2) not null
);

alter table track
    owner to chinook;

create index track_album_id_idx
    on track (album_id);

create index track_genre_id_idx
    on track (genre_id);

create index track_media_type_id_idx
    on track (media_type_id);

