create table if not exists account
( id serial not null primary key
, guid uuid not null unique default gen_random_uuid()
, email text not null unique
, active boolean not null default TRUE
, created_at timestamptz not null default now()
);
