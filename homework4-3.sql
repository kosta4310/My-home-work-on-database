create schema shop;
--везде нужно дописывать название схемы
create table shop.products(
product_id int primary key,
product_name varchar(30),
product_supplier varchar(30),
price numeric not null,
expiration_date date,
constraint un_pr_n_pr_sup unique (product_name,product_supplier)
);
--drop table products ;

insert into shop.products values
(20,'H&S Shampoo','P&G',128.5,'4/5/2022'),
(25,'Milka','Nestle',41,'7/6/2021'),
(15,'iPhone 11 64 GB','Apple',22500,'10/7/2024'),
(80,'Varvar Stout','Varvar',55,'10/8/2021'),
(77,'iPad Pro 128 GB','Apple',20000,'1/9/2024'),
(64,'Morshinska 1.5L green','IDS',13.5,'10/10/2021'),
(17,'Blend a med','P&G',38,'6/11/2021'),
(44,'Varvar IPA','Varvar',50,'10/12/2021'),
(56,'Q80T 55 inch TV','Samsung',35000,'5/1/2023'),
(70,'Leleka Cabernet','Leleka Wines',160,'2/1/2022');
--delete from products ;
create table shop.customers (
id_customer serial primary key,
customer_name varchar(30) not null,
address varchar(80)
);
--drop table customers ;
--alter table customers 
--drop column id_level ;




create table shop.levels_customers(
id_level varchar(10) primary key
);

alter table shop.levels_customers 
rename column id_level to level;

alter table shop.levels_customers 
drop constraint levels_customers_pkey;

alter table shop.levels_customers
add column id_level serial primary key;

alter table shop.customers 
add column id_level int references shop.levels_customers(id_level);

create table shop.orders(
id_product int ,
id_customer int ,
quntity_sold int not null,
price_sold numeric 
);
 


alter table shop.orders 
add constraint pr__pr_fkey foreign key (id_product) references shop.products(product_id),
add constraint cus_cus_fkey foreign key (id_customer) references shop.customers(id_customer);



alter table shop.orders 
alter column price_sold
set not null ;

alter table shop.orders 
add column id_orders serial primary key;

alter table shop.orders 
add column transaction_date date default now()::date;




insert into shop.levels_customers values
('Basic'),
('Gold'),
('Silver');

insert into shop.customers (customer_name,address,id_level)values
('Miroslava','Svobody 17',1),
('Ivan','Zelena 5',2),
('Olena','Chernova 7',3),
('Oleksiy','Dubova 40',1),
('Petro','Kashtanova 1',3),
('Sergiy','Lisova 53',1),
('Natalka','Svobody 71',1),
('Vasyl','Platonova 4',2),
('Solomiya','Bankova 16',3),
('Oleg','Sribna 31',1);



insert into shop.orders (id_product,quntity_sold,price_sold,id_customer ,transaction_date) values
(20,3,135,1,'5/1/2021'),
(25,50,42.5,2,'5/1/2021'),
(15,2,24000,3,'5/1/2021'),
(80,24,60,4,'5/2/2021'),
(77,1,21000,5,'5/2/2021'),
(64,18,15,6,'5/1/2021'),
(17,5,40,7,'5/2/2021'),
(44,20,55,8,'5/3/2021'),
(56,1,37500,9,'5/3/2021'),
(70,6,175,10,'5/1/2021');

select p.product_id ,p.product_name ,p.product_supplier ,p.price ,p.expiration_date ,o.transaction_date ,o.quntity_sold ,
c.customer_name ,c.address ,lc.level, o.price_sold from shop.orders o 
join shop.products p on p.product_id = o.id_product 
join shop.customers c on c.id_customer = o.id_customer 
join shop.levels_customers lc on lc.id_level =c.id_level ;

--drop schema shop cascade;

