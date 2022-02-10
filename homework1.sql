create table my_table(airport_my text,aitpeof integer);
insert into my_table values ('dfd',54);
drop table my_table ;
create table public.homework 
(product_id integer,
product_name text,
product_supplier text,
barcode numeric,
price decimal,
quantity int,
expiration_date date
);

insert into public.homework values 
(20,'H$S Shampoo','P&G',4820004385257,128.5,50,'2022-04-05');

insert into public.homework values
(25,'Milka','Nestle',4820004385256,41,2000,'2021-07-06');

insert into public.homework values
(15,'IPhone 11 64 GB','Apple',4820004385255,22500,10,'2024-10-07'),
(80,'Varvar Stout','Varvar',4820004385254,55,100,'2021-10-08'),
(77,'iPad Pro 128 GB','Apple',4820004385253,20000,5,'2024-01-09'),
(64,'Morshinska 1.5L green','IDS',4820004385250,13.5,240,'2021-10-10'),
(17,'Blend a med','P&G',4820004385260,38,100,'2021-06-11'),
(44,'Varvar IPA','Varvar',4820004385270,50,24,'2021-10-12'),
(56,'Q80T 55 inch TV','Samsung',4820004385280,35000,5,'2023-05-01'),
(70,'Leleka Cabernet','Leleka Wines',4820004385290,160,48,'2022-02-01');


drop table public.homework ;

select * from public.homework;

--homework output 1
select * from public.homework order by price desc;
--1 подпункт два:
-- их всего пять, поэтому ограничил 3
select product_name,expiration_date from public.homework where 
expiration_date < '2021-12-04' limit 3;
--2
select product_name from public.homework where 
product_supplier ='Apple';
--3
select product_name,price from public.homework where 
price >100;
--4
delete from  public.homework  where 
product_supplier ='Varvar';
--5
insert into public.homework values
(80,'Varvar Stout','Varvar',4820004385254,55,100,'2021-10-08'),
(44,'Varvar IPA','Varvar',4820004385270,50,24,'2021-10-12');
--6
select price * quantity as cost_all_Iphone11 from public.homework where 
product_name ='IPhone 11 64 GB';
--7
select product_name ,expiration_date  from public.homework where 
expiration_date between '2021-01-01' and '2021-12-31';
