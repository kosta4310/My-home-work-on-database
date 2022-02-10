--10 passengers, who flew from New York and their summary amount spent on bookings > $1000, sorted alphabetically
select t.passenger_name,sum(tf.amount)from flights f 
join airports a on a.airport_code =f.departure_airport 
join ticket_flights tf on tf.flight_id = f.flight_id 
join tickets t on t.ticket_no = tf.ticket_no 
where a.city = 'New York'
group by 1
having sum(tf.amount)>1000
order by 1
limit 10;

--# of flights from Newark to San Diego
select count(*) from flights f 
join airports dep on dep.airport_code = f.departure_airport 
join airports arr on arr.airport_code =f.arrival_airport 
where dep.city = 'Newark'
and arr.city = 'San Diego';

--# of flights from Tucumcari when seat 3A was occupied
select count(*) from flights f 
join airports a on a.airport_code = f.departure_airport 
join ticket_flights tf on tf.flight_id = f.flight_id 
join boarding_passes bp on bp.ticket_no = tf.ticket_no 
where a.city = 'Tucumcari'
and bp.seat_no = '3A';

--Min, Max and Average number of passengers per flight on route from Cincinnati to Newark
--select f.flight_id ,count(*) as cnt from flights f 
--join airports dep on dep.airport_code = f.departure_airport 
--join airports arr
--on arr.airport_code = f.arrival_airport 
--join ticket_flights tf on tf.flight_id = f.flight_id 
--join boarding_passes bp on bp.ticket_no = tf.ticket_no 
--where dep.city = 'Cincinnati'
--and arr.city = 'Newark'
--group by f.flight_id ;
--
--select min(t1.cnt),max(t1.cnt),avg(t1.cnt) from
--(select f.flight_id ,count(*) as cnt from flights f 
--join airports dep on dep.airport_code = f.departure_airport 
--join airports arr on arr.airport_code = f.arrival_airport 
--join ticket_flights tf on tf.flight_id = f.flight_id 
--join boarding_passes bp on bp.ticket_no = tf.ticket_no 
--where dep.city = 'Cincinnati'
--and arr.city = 'Newark'
--group by f.flight_id 
--)t1;
select f.flight_id ,bp.boarding_no as cnt
from flights f 
join airports dep on dep.airport_code = f.departure_airport 
join airports arr on arr.airport_code = f.arrival_airport 
join boarding_passes bp on bp.flight_id = f.flight_id 
where dep.city = 'Cincinnati'
and arr.city = 'Newark'
and f.flight_id ='56615'

select f.flight_id ,count(bp.seat_no) as cnt
from flights f 
join airports dep on dep.airport_code = f.departure_airport 
join airports arr on arr.airport_code = f.arrival_airport 
join boarding_passes bp on bp.flight_id = f.flight_id 
where dep.city = 'Cincinnati'
and arr.city = 'Newark'
group by 1
;

--this is right
--A4 Min, Max and Average number of passengers per flight on route from Cincinnati to Newark
select min(t1.cnt),max(t1.cnt),avg(t1.cnt) from 
(select f.flight_id ,
count(bp.boarding_no) as cnt
from flights f 
join airports dep on dep.airport_code = f.departure_airport 
join airports arr on arr.airport_code = f.arrival_airport 
join boarding_passes bp on bp.flight_id = f.flight_id 
where dep.city = 'Cincinnati'
and arr.city = 'Newark'
group by 1)t1;


--Complete list of all cities and # of departure flights per each city during 2016-08-01. There should be no duplicates.

select t1.city,t2.cnt from 
(select distinct a.city from airports a ) t1
left join
(select a.city 
,count(f.flight_id) as cnt
from airports a 
join flights f on a.airport_code = f.departure_airport 
where f.scheduled_departure::DATE = '2016-08-01'
group by a.city )t2
on t1.city=t2.city;

--Create new work table (b_ny_flights) in public schema. Insert into it data for all flights from New York during Aug-Sept 2016. Table structure is up to you,
--but consider further instructions.

create table public.b_ny_flight as 
select dep.city as departure_city,arr.city as arrival_city,f.scheduled_departure::date as date_departure from flights f 
join airports dep on dep.airport_code =f.departure_airport 
join airports arr on arr.airport_code = f.arrival_airport 
where dep.city = 'New York'
and f.scheduled_departure between '2016-08-01' and '2016-10-01';
drop table b_ny_flight ;
--B1 Output the # of destination cities for flights in work table
select count(*) from 
(select distinct bnf.arrival_city 
from public.b_ny_flight bnf)t1;


--Delete all flights from work table that have Chicago and Los Angeles as destination
delete from public.b_ny_flight 
where arrival_city = 'Chicago'
or arrival_city = 'Los Angeles';

--Output the list of destination cities for New York departure flights from booking.flights table, which are absent in new work table. Do not use date
--filters on booking.flights table!

select arr.city from flights f 
join airports dep on dep.airport_code = f.departure_airport 
join airports arr on arr.airport_code =f.arrival_airport 
where dep.city = 'New York'
except 
select bnf.arrival_city from public.b_ny_flight bnf ;

select bnf.departure_city ,bnf.arrival_city,bnf.date_departure from public.b_ny_flight bnf
order by bnf.date_departure desc;

--Output from table you’ve created during homework #1 (with products like iPhone, Varvar):
--Total stock value (price * quantity) per supplier

select h.product_supplier ,sum(h.price*h.quantity) from public.homework h
group by 1;

--Product with minimal price per supplier
select h.product_supplier , min(price) from public.homework h
group by 1;

select h.product_name,h.product_supplier from public.homework h
join (select h.product_supplier , min(price) from public.homework h group by 1) t1 
on t1.min=h.price ;

--Average price across all products
select avg(h.price) from public.homework h;

--Count of products cost less than 1000 per supplier
select h.product_supplier ,count(h.product_id) from public.homework h
where h.price <1000
group by 1;




