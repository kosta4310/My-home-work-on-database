create schema sanctions;

create table sanctions.entities
(id_int serial,
caption text,
datasets text array,
first_seen text,
id text,
last_seen text,
referents text array,
schema text,
target text,
primary key (id),
unique(id_int)
);

create table sanctions.thing
(general_id text,
address text array,
addressEntity text array,
alias text array,
country text array,
description text array,
keywords text array,
modifiedAt text array,
name text array,
notes text array,
previousName text array,
program text array,
publisher text array,
publisherUrl text array,
retrievedAt text array,
sanctions text array,
sourceUrl text array,
summary text array,
topics text array,
unknownLinkFrom text array,
unknownLinkTo text array,
weakAlias text array,
wikidataId text array,
wikipediaUrl text array,
primary key (general_id),
foreign key (general_id) references sanctions.entities(id)
);