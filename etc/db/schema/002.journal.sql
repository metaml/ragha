create table if not exists journal
( id serial not null primary key
, guid uuid not null references account(guid)
, entry text not null
, created_at timestamptz not null default now()
);
