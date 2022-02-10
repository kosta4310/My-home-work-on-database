--1. List of aircraft models departed from Buffalo
select distinct a.model from aircrafts a 
join flights f on f.aircraft_code = a.aircraft_code 
join airports a2 on a2.airport_code =f.departure_airport 
where a2.city ='Buffalo';

--2. List of cities in timezone America/New_York served by Boeing 737-300
select distinct a2.city from aircrafts a 
join flights f on f.aircraft_code = a.aircraft_code 
join airports a2 on a2.airport_code =f.departure_airport 
where a2.timezone = 'America/New_York'
and a.model ='Boeing 737-300';

--3. 10 passengers sorted alphabetically who spend less than $200 per at least 1 booking (not flight).
select distinct t.passenger_name from tickets t 
join bookings b on b.book_ref = t.book_ref 
where b.total_amount <200
order by t.passenger_name 
limit 10;

--4. Delayed flights (arrival city, aircraft model) from Washington in October 2016 
--select f.arrival_airport ,a2.model,f.scheduled_departure,a.city,f.status from flights f
--join airports a on a.airport_code = f.departure_airport 
--join aircrafts a2 on a2.aircraft_code =f.aircraft_code 
--where 
--f.status ='Delayed'
--and a.city = 'Washington'
--and f.scheduled_departure >= to_timestamp('01 Oct 2016 ', 'DD Mon YYYY')
--and f.scheduled_departure <=to_timestamp('31 Oct 2016','DD Mon YYYY') 
--; 

select t1.city as departed_city,a3.city as arrival_city,t1.model,t1.scheduled_departure,t1.status 
from (select f.arrival_airport ,a2.model,f.scheduled_departure,a.city,f.status from flights f
join airports a on a.airport_code = f.departure_airport 
join aircrafts a2 on a2.aircraft_code =f.aircraft_code 
where 
f.status ='Delayed'
and a.city = 'Washington'
and f.scheduled_departure >= to_timestamp('01 Oct 2016 ', 'DD Mon YYYY')
and f.scheduled_departure <=to_timestamp('31 Oct 2016','DD Mon YYYY') )as t1
join airports a3 on a3.airport_code =t1.arrival_airport;

--5. Cancelled flights (arrival city, aircraft model) from Chicago
select a2.model ,a.city ,f.status from flights f 
join airports a on a.airport_code =f.departure_airport 
join aircrafts a2 on a2.aircraft_code =f.aircraft_code 
where f.status ='Cancelled'
and a.city ='Chicago';

select t1.city as departed_city,a3.city as arrival_city ,t1.model,t1.status 
from (select f.arrival_airport,a2.model ,a.city ,f.status from flights f 
join airports a on a.airport_code =f.departure_airport 
join aircrafts a2 on a2.aircraft_code =f.aircraft_code 
where f.status ='Cancelled'
and a.city ='Chicago') as t1
join airports a3 on a3.airport_code =t1.arrival_airport;

--6. Arrival airports for flights, served by aircrafts which range < 3000 km, departed from Miami
select distinct a.city as departed_city,a2."range",f.arrival_airport from flights f 
join airports a on a.airport_code = f.departure_airport 
join aircrafts a2 on a2.aircraft_code =f.aircraft_code 
where a.city ='Miami'
and a2."range" <3000;

select t1.departed_city,t1.range,t1.arrival_airport,a3.city as arrival_city
from (select distinct a.city as departed_city,a2."range",f.arrival_airport from flights f 
join airports a on a.airport_code = f.departure_airport 
join aircrafts a2 on a2.aircraft_code =f.aircraft_code 
where a.city ='Miami'
and a2."range" <3000) as t1
join airports a3 on a3.airport_code =t1.arrival_airport;


