create table data_set (ID_SanctionDataset serial primary key , NameOfSanctionDataset varchar(3) unique not null);
insert into data_set(NameOfSanctionDataset) values ('usa'),('eu');

create table Country (ID_Country serial primary key, CountryName varchar (50) unique not null);
insert into country (CountryName) values ('Ukraine'), ('RussianFederation'), ('Iran'), ('UK'), ('Belarus');

create table Referents (ID_Referents serial primary key, ReferenseOnSanctionDoc varchar (50) unique not null);
insert into referents (ReferenseOnSanctionDoc) values ('eu-fsf-eu-5896-1'), ('eu-fsf-eu-5896-2'), ('us-fsf-548xz -7');

create table San_schema (ID_schema serial primary key, San_schema varchar (50) unique not null);
insert into san_schema (San_schema) values ('Person'), ('Organization');

create table Sanctions (ID_Sanction serial primary key,
ID_SanctionDataset int references data_set, 
ID_Referents int  references Referents,
ID_Country int  references Country,
DateFirstSeen date,
DateLasttSeen date,
ID_schema int references San_schema, 
Discribe text,
CompanyName text,
LastName text, 
FirstName text);




insert into Sanctions (ID_SanctionDataset, ID_Referents, ID_Country, DateFirstSeen, DateLasttSeen, ID_schema, Discribe,
CompanyName, LastName, FirstName)
values
(1, 1, 1, '2021-12-01', '2021-12-18', 2, 'Company1', 'Company1', null, null),
(1, 1, 2, '2021-12-01', '2021-12-18', 1, 'Family1Name1', null, 'Family1', 'Name1'),
(2, 3, 3, '2021-12-01', '2021-12-18', 2, 'Company2', 'Company2', null, null),
(2, 3, 4, '2021-12-01', '2021-12-18', 1, 'Family2Name2', null, 'Family2', 'Name2'),
(1, 2, 5, '2021-12-01', '2021-12-18', 2, 'Company3', 'Company3', null, null),
(1, 2, 5, '2021-12-01', '2021-12-18', 1, 'Family3Name3', null, 'Family3', 'Name3');



select
     n.nspname  as "Schema"
    ,t.relname  as "Table"
    ,c.relname  as "Index"
from
          pg_catalog.pg_class c
     join pg_catalog.pg_namespace n on n.oid        = c.relnamespace
     join pg_catalog.pg_index i     on i.indexrelid = c.oid
     join pg_catalog.pg_class t     on i.indrelid   = t.oid
where
        c.relkind = 'i'
    and n.nspname not in ('pg_catalog', 'pg_toast')
    and pg_catalog.pg_table_is_visible(c.oid)
order by
     n.nspname
    ,t.relname
    ,c.relname;
   
 
   
