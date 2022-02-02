--1 Create a user reporter. Grant him permissions to select data from all objects in bookings schema.
-- Then revoke grants for select on tables: boarding_passes, tickets, bookings. 
--Test the changes under reporter connection.

create user reporter password 'repouser';
grant all on schema bookings to reporter;
grant select on all tables in schema bookings to reporter;

revoke select on table  
bookings.boarding_passes,
bookings.tickets,
bookings.bookings
from reporter;

select *
from information_schema.role_table_grants 
where grantee='reporter';

--2 Create a new table as SELECT * FROM booking.flights. 
--Add 2 new columns: economy_avg and business_avg. 
--Update a table by filling these new columns: 
--average # of Economy and Business seats occupied per corresponding date (use scheduled_departure column as reference).

create table  book_fl_bussness_economy as select * from  bookings.flights;

alter table book_fl_bussness_economy 
add column economy_avg  decimal;
alter table book_fl_bussness_economy 
add column business_avg  decimal;

Ѕудем считать что купленные билеты это и есть зан€тые места, вместо того чтобы считать реально зан€тые места в 
самолете по посадочным талонам. ѕон€тно что небольшое отличие будет.

ѕодсчитываем количество бизнес и эконом мест по каждому рейсу в разрезе дат,
а потом среднее количество этих мест по рейсам в разрезе дат.

with cnt_business as
(select f.scheduled_departure,count(tf.ticket_no) as cnt_b from bookings.flights f 
join bookings.ticket_flights tf on tf.flight_id= f.flight_id
where tf.fare_conditions = 'Business'
group by 1),
cnt_economy as
(select f.scheduled_departure,count(tf.ticket_no) as cnt_e from bookings.flights f 
join bookings.ticket_flights tf on tf.flight_id= f.flight_id
where tf.fare_conditions = 'Economy'
group by 1)
update public.book_fl_bussness_economy bfbe set
business_avg = t1.avg_business,
economy_avg = t1.avg_econom from
(select cb.scheduled_departure::date,
avg(cb.cnt_b) as avg_business,
avg(ce.cnt_e) as avg_econom
from cnt_business cb
join cnt_economy ce
using (scheduled_departure)
group by 1)t1
where bfbe.scheduled_departure::date = t1.scheduled_departure
returning bfbe.*;

select * from public.book_fl_bussness_economy bb
order by bb.scheduled_departure;

--3. Take the table you created in #2 and delete from it data for 50 worst performing airports (they have less flights).
—делал копии удаленных записей. “ак видно количество и можно контролировать процесс удалени€.

begin;
copy (
with worst_performing_airports as
(select bb.departure_airport,count(distinct bb.flight_id)
from public.book_fl_bussness_economy bb
group by 1
order by 2
limit 50)
delete from public.book_fl_bussness_economy bbe
using worst_performing_airports wpa 
where bbe.departure_airport = wpa.departure_airport
returning *
) to 'G:\database\vcs\My-home-work-on-database\test_copy.txt' (delimiter '|',format csv,header);
commit;

