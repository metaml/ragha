create table if not exists journal
( id serial not null primary key
, entry text not null
, email text not null
, created_at timestamptz not null default now()
);
