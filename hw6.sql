--2 Find the passenger(s) (up to 5) flew from New York with the shortest and longest name + surname.
select distinct t.passenger_name,length(t.passenger_name) as min_value
from bookings.flights f
join bookings.airports dep on dep.airport_code= f.departure_airport
join bookings.ticket_flights tf on tf.flight_id= f.flight_id
join bookings.tickets t on t.ticket_no=tf.ticket_no
where dep.city='New York'
order by 2,1
limit 5;

select distinct t.passenger_name,length(t.passenger_name) as max_value
from bookings.flights f
join bookings.airports dep on dep.airport_code= f.departure_airport
join bookings.ticket_flights tf on tf.flight_id= f.flight_id
join bookings.tickets t on t.ticket_no=tf.ticket_no
where dep.city='New York'
order by 2 desc,1
limit 5;

--3 Find the passenger(s) (up to 5) with longest and shortest e-mails and output them in lower case.
select distinct lower(t.passenger_name), coalesce(length(t.contact_data->>'email'),0) as max_value
from bookings.tickets t
order by 2 desc ,1
limit 5;

select distinct lower(t.passenger_name), length(t.contact_data->>'email') as min_value
from bookings.tickets t
order by 2  ,1
limit 5;

--4 Output # of passengers flew to Miami having ‘3564’ sequence in their phone

select count(distinct t.passenger_name)
from bookings.flights f
join bookings.airports dep on dep.airport_code= f.departure_airport
join bookings.ticket_flights tf on tf.flight_id= f.flight_id
join bookings.tickets t on t.ticket_no=tf.ticket_no
where dep.city='Miami' and
t.contact_data->>'phone'like '%3564%';

--5 Unload such dataset: passenger name, destination city, total booking amount for flights from Boston during July’16 
--to flat file on your computer, using ;  (semicolon) as the delimiter

Что с дистинкт что без него количество строк одинаковое но как правильно нужно не понял 
так как не знаю что это за total_amount.
Выборка сделана но New York. Причины уже везде где можно расписал.

copy 
(select distinct t.passenger_name,arr.city,bb.total_amount
from bookings.flights f
join bookings.airports dep on dep.airport_code= f.departure_airport
join bookings.airports arr on arr.airport_code= f.arrival_airport
join bookings.ticket_flights tf on tf.flight_id = f.flight_id
join bookings.tickets t on t.ticket_no=tf.ticket_no
join bookings.bookings bb on bb.book_ref= t.book_ref
where dep.city = 'New York' and
f.scheduled_departure::date between '2016-07-01' and '2016-08-01'
order by 1) to 'G:\database\exersize6-5.txt' (delimiter ';',format csv,header );

--6 You flat file attached (streams.txt) with header. It contains some statistics of listening (streams) some music track across countries (2 digit ISO format, e.g. US, UK, FR). Create a table in a database and load data from file. Then output:
--Country with the highest and lowest # of streams
--Date with the highest # of listeners
--Average # of streams per date

begin;
set datestyle to mdy;
drop table if exists statistic_music;
create table statistic_music (ISRC varchar,
Partner_Tack_ID varchar,
date date,
category varchar,
dimension varchar(2),
streams numeric,
listeners numeric);
copy public.statistic_music from 'G:\database\streams.txt' (delimiter ',',format csv,header);

--country with min number streams

select t.dimension as country_min,
sum(t.streams)as sum
from public.statistic_music t
group by t.dimension
order by sum
limit 1;

--country with max number streams

select t.dimension as country_max,
sum(t.streams)as sum
from public.statistic_music t
group by t.dimension
order by sum desc
limit 1;

--Date with the highest # of listeners

SELECT t.date,sum(t.listeners) 
from public.statistic_music t
group by t.date
order by sum(t.listeners) desc
limit 1;

--Average # of streams per date

SELECT t.date,round(avg(t.streams)::numeric,1) 
from public.statistic_music t
group by t.date;

commit;
rollback;


