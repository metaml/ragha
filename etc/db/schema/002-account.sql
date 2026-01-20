create table if not exists account
( id serial not null primary key
, email text not null unique
, password text not null
, active boolean not null default TRUE
, guid uuid not null unique default gen_random_uuid()
, created_at timestamptz not null default now()
);
