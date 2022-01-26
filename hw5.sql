
1.Create a function which:
-has input parameters: departure and arrival airports, scheduled date
-outputs the flight number, list of passengers with their seats

Provide some sample function calls
2.Create a procedure which:
-Will create a new table in public schema
-Fill it with data from bookings schema: departure city, arrival city, arrival date, # (quantity) of economy seats, # of business class seats occupied per date

Please note – data in table has to be rewritten completely every time you call the procedure

3. Create a new table.

Create a procedure which fills new table with data provided by function from #1. There’re should be no duplicates for specific date.

4. You have a mapping for timezones and regions: America/New_York -> East; America/Phoenix, America/Denver, America/Chicago -> Center; America/Los_Angeles -> West.


Create a function that will return average number of departed passengers per flight per region for provided date.
Input for function: date
Output: List of regions and average # of
passengers per flight for this date.
Комментарии
Мои задания
Сдано

hw5.sql
SQL
1 личный комментарий

Костянтин Павлов19 янв.
Как то все сложно вышло опять.

--1 Create a function which:
--has input parameters: departure and arrival airports, scheduled date
--outputs the flight number, list of passengers with their seats 
--Provide some sample function calls
--

create or replace function public.fn_get_list_passengers_per_flight 
(in_departure_airport varchar,in_arrival_airport varchar,in_scheduled_date date) 
returns table (flight_no bpchar(6),passenger_name text,seat varchar(4)) as
$$
begin
	return query
select f.flight_no , t.passenger_name ,bp.seat_no from bookings.flights f 
join bookings.boarding_passes bp on bp.flight_id = f.flight_id 
join bookings.tickets t on t.ticket_no = bp.ticket_no 
where f.scheduled_departure::date = $3
and f.departure_airport =$1
and f.arrival_airport = $2;
end;
$$ language plpgsql;

--drop function public.fn_get_list_passengers_per_flight;

select * from public.fn_get_list_passengers_per_flight
('JFK','SBD','2016-09-14');
select * from public.fn_get_list_passengers_per_flight
('JFK','SBD','2016-09-16');

--2 Create a procedure which:
--Will create a new table in public schema
--Fill it with data from bookings schema: departure city, arrival city, arrival date, # (quantity) of economy seats, # of business class seats occupied per date
--Please note – data in table has to be rewritten completely every time you call the procedure

create or replace procedure public.sp_create_table_booking_per_date
(in_departure_date date)
language plpgsql as
$$
begin 
	create table if not exists  public.booking_per_date 
		(departure_city text,
		arrival_city text,
		arrival_date timestamptz,
		quantity_economy_seats_occupied int,
		quantity_business_class_seats_occupied int);
	truncate public.booking_per_date ;
	insert into public.booking_per_date 
		(select dep.city as dep_city,
			arr.city as arr_city,
			f.scheduled_arrival as arrival_date ,
			t1.fce as quantity_economy_seats_occupied,
			t1.fcb as quantity_business_class_seats_occupied
			from bookings.flights f 
			join bookings.airports arr on arr.airport_code = f.arrival_airport 
			join bookings.airports dep on dep.airport_code = f.departure_airport 
			join 
				(select f.flight_id ,
					sum(case when tf.fare_conditions='Economy' then 1 else 0 end) as fce,
					sum(case when tf.fare_conditions='Business' then 1 else 0 end) as fcb
					from bookings.flights f 
					join bookings.ticket_flights tf on tf.flight_id = f.flight_id 
					where f.scheduled_departure ::date = $1
					group by 1) t1 on t1.flight_id= f.flight_id );
end;
$$;

--drop procedure public.sp_create_table_booking_per_date;
drop table public.booking_per_date ;
call public.sp_create_table_booking_per_date('2016-10-10');
call public.sp_create_table_booking_per_date('2016-10-14');
select * from public.booking_per_date bpd ;

--select f.flight_id ,
--sum(case when tf.fare_conditions='Economy' then 1 else 0 end) as fce,
--sum(case when tf.fare_conditions='Business' then 1 else 0 end) as fcb
--from bookings.flights f 
--join bookings.ticket_flights tf on tf.flight_id = f.flight_id 
--where f.scheduled_departure ::date = '2016-10-10'
--group by 1;
--
--select dep.city as dep_city,
--arr.city as arr_city,
--f.scheduled_arrival as arrival_date ,
--t1.fce as quantity_economy_seats_occupied,
--t1.fcb as quantity_business_class_seats_occupied
--from bookings.flights f 
--join bookings.airports arr on arr.airport_code = f.arrival_airport 
--join bookings.airports dep on dep.airport_code = f.departure_airport 
--join 
--(select f.flight_id ,
--sum(case when tf.fare_conditions='Economy' then 1 else 0 end) as fce,
--sum(case when tf.fare_conditions='Business' then 1 else 0 end) as fcb
--from bookings.flights f 
--join bookings.ticket_flights tf on tf.flight_id = f.flight_id 
--where f.scheduled_departure ::date = '2016-10-10'
--group by 1) t1 on t1.flight_id= f.flight_id ;

--3. Create a new table.
--Create a procedure which fills new table with data provided by function from #1.
-- There’re should be no duplicates for specific date.

create or replace procedure public.sp_list_passengers_per_flight
(departure_airport varchar,arrival_airport varchar,scheduled_date date)
language plpgsql as 
$$
begin 
	create table if not exists public.list_passengers_per_flight (flight_no bpchar(6),passenger_name text,seat varchar(4));
	truncate table public.list_passengers_per_flight ;
	insert into public.list_passengers_per_flight(flight_no,passenger_name,seat) 
	(select * from public.fn_get_list_passengers_per_flight($1,$2,$3));
end;
$$;

call public.sp_list_passengers_per_flight('JFK','SBD','2016-09-14') ;
call public.sp_list_passengers_per_flight('JFK','SBD','2016-09-16') ;
select * from public.list_passengers_per_flight lppf ;
--drop table public.list_passengers_per_flight;

--4. You have a mapping for timezones and regions: America/New_York -> East; America/Phoenix, America/Denver, America/Chicago -> Center; America/Los_Angeles -> West.
--Create a function that will return average number of departed passengers per flight per region for provided date.
--Input for function: date
--Output: List of regions and average # of
--passengers per flight for this date.

--subquery подсчет количества перевезенных пассажиров за рейс
select f.flight_id ,count(bp.boarding_no) from bookings.flights f 
join bookings.boarding_passes bp on bp.flight_id = f.flight_id 
group by 1;



create or replace function public.fn_avg_passengers_per_regions (in_departure_date date)
returns table (time_region text,average_passenger decimal) as
$$
begin
	return query
	select (
case 
	when a.timezone = 'America/New_York' then 'East'
	when a.timezone = 'America/Los_Angeles' then 'West'
	else 'Center'
end
) as time_region,
avg(t1.cnt) as average_passenger
from bookings.flights f 
join bookings.airports a on a.airport_code = f.departure_airport 
join (select f.flight_id ,count(bp.boarding_no) as cnt from bookings.flights f 
join bookings.boarding_passes bp on bp.flight_id = f.flight_id 
group by 1) as t1 on t1.flight_id= f.flight_id 
where  f.scheduled_departure::date = $1
group by (
case 
	when a.timezone = 'America/New_York' then 'East'
	when a.timezone = 'America/Los_Angeles' then 'West'
	else 'Center'
end
);
end;
$$language plpgsql;

select * from public.fn_avg_passengers_per_regions('2016-09-16');
--drop function public.fn_avg_passengers_per_regions;

hw5.sql
Открыт файл "hw5.sql"Подождите…