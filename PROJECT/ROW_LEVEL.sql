---role level and column level security-----
---creating configuration table---
---role level and column level security-----
---creating configuration table---
create or replace table configuration_table (AIRLINE_ROLE VARCHAR,AIR_LINE VARCHAR);

insert into configuration_table(AIRLINE_ROLE,AIR_LINE) values('SPICEJET_AIRLINE_ROLE1','SpiceJet');
insert into configuration_table(AIRLINE_ROLE,AIR_LINE) values('AIRASIA_AIRLINE_ROLE1','AirAsia');
insert into configuration_table(AIRLINE_ROLE,AIR_LINE) values('AIR_INDIA_AIRLINE_ROLE1','Air_India');
insert into configuration_table(AIRLINE_ROLE,AIR_LINE) values('VISTARA_AIRLINE_ROLE1','Vistara');
insert into configuration_table(AIRLINE_ROLE,AIR_LINE) values('GO_FIRST_AIRLINE_ROLE1','GO_FIRST');


SELECT * FROM CONFIGURATION_TABLE;

---CREATING SECURE VIEW-----
create or replace secure view flights_secure_view1 as
select (SSN,AIR_LINE,FLIGHT,SOURCE_CITY,DEPARTURE_TIME,STOPS,ARRIVAL_TIME,
        destination_city,CLASS,DURATION,DAYS_LEFT,PRICE)
from flights_table
where air_line in 
(select air_line from configuration_table where AIRLINE_ROLE = CURRENT_ROLE());

select * from flights_secure_view1;

-----creating roles-----
use role useradmin;
create or replace role SPICEJET_AIRLINE_ROLE1;
create or replace role AIRASIA_AIRLINE_ROLE1;
create or replace role AIR_INDIA_AIRLINE_ROLE1;
create or replace role VISTARA_AIRLINE_ROLE1;
create or replace role GO_FIRST_AIRLINE_ROLE1;


-----granting permissions-------
use role sysadmin;
grant usage on warehouse compute_Wh to role SPICEJET_AIRLINE_ROLE1;
grant usage on warehouse compute_Wh to role AIRASIA_AIRLINE_ROLE1;
grant usage on warehouse compute_Wh to role AIR_INDIA_AIRLINE_ROLE1;
grant usage on warehouse compute_Wh to role VISTARA_AIRLINE_ROLE1;
grant usage on warehouse compute_Wh to role GO_FIRST_AIRLINE_ROLE1;



use role accountadmin;
grant usage on database FLIGHT_DATABASE to role SPICEJET_AIRLINE_ROLE1;
grant usage on database FLIGHT_DATABASE to role AIRASIA_AIRLINE_ROLE1;
grant usage on database FLIGHT_DATABASE to role AIR_INDIA_AIRLINE_ROLE1;
grant usage on database FLIGHT_DATABASE to role VISTARA_AIRLINE_ROLE1;
grant usage on database FLIGHT_DATABASE to role GO_FIRST_AIRLINE_ROLE1;



grant usage on schema PUBLIC to role SPICEJET_AIRLINE_ROLE1;
grant usage on schema PUBLIC to role AIRASIA_AIRLINE_ROLE1;
grant usage on schema PUBLIC to role AIR_INDIA_AIRLINE_ROLE1;
grant usage on schema PUBLIC to role VISTARA_AIRLINE_ROLE1;
grant usage on schema PUBLIC to role GO_FIRST_AIRLINE_ROLE1;



grant select on view FLIGHT_DATABASE.PUBLIC.flights_secure_view1 to role SPICEJET_AIRLINE_ROLE1;
grant select on view FLIGHT_DATABASE.PUBLIC.flights_secure_view1 to role AIRASIA_AIRLINE_ROLE1;
grant select on view FLIGHT_DATABASE.PUBLIC.flights_secure_view1 to role AIR_INDIA_AIRLINE_ROLE1;
grant select on view FLIGHT_DATABASE.PUBLIC.flights_secure_view1 to role VISTARA_AIRLINE_ROLE1;
grant select on view FLIGHT_DATABASE.PUBLIC.flights_secure_view1 to role GO_FIRST_AIRLINE_ROLE1;


------creating user----------
create or replace user vishu123 password = 'vishu123' default_Role = 'PUBLIC';
grant role SPICEJET_AIRLINE_ROLE1 to user vishu123;
grant role AIRASIA_AIRLINE_ROLE1 to user vishu123;
grant role AIR_INDIA_AIRLINE_ROLE1 to user vishu123;
grant role VISTARA_AIRLINE_ROLE1 to user vishu123;
grant role GO_FIRST_AIRLINE_ROLE1 to user vishu123;



-----creating masking ---------
grant create masking policy on schema FLIGHT_DATABASE.public to role SPICEJET_AIRLINE_ROLE1;
grant create masking policy on schema FLIGHT_DATABASE.public to role AIRASIA_AIRLINE_ROLE1;
grant create masking policy on schema FLIGHT_DATABASE.public to role AIR_INDIA_AIRLINE_ROLE1;
grant create masking policy on schema FLIGHT_DATABASE.public to role VISTARA_AIRLINE_ROLE1;
grant create masking policy on schema FLIGHT_DATABASE.public to role GO_FIRST_AIRLINE_ROLE1;



grant apply masking policy on account to role SPICEJET_AIRLINE_ROLE1;
grant apply masking policy on account to role AIRASIA_AIRLINE_ROLE1;
grant apply masking policy on account to role AIR_INDIA_AIRLINE_ROLE1;
grant apply masking policy on account to role VISTARA_AIRLINE_ROLE1;
grant apply masking policy on account to role GO_FIRST_AIRLINE_ROLE1;



grant usage on database FLIGHT_DATABASE to role SPICEJET_AIRLINE_ROLE1;
grant usage on database FLIGHT_DATABASE to role AIRASIA_AIRLINE_ROLE1;
grant usage on database FLIGHT_DATABASE to role AIR_INDIA_AIRLINE_ROLE1;
grant usage on database FLIGHT_DATABASE to role VISTARA_AIRLINE_ROLE1;
grant usage on database FLIGHT_DATABASE to role GO_FIRST_AIRLINE_ROLE1;



grant usage on schema FLIGHT_DATABASE.public to role SPICEJET_AIRLINE_ROLE1;
grant usage on schema FLIGHT_DATABASE.public to role AIRASIA_AIRLINE_ROLE1;
grant usage on schema FLIGHT_DATABASE.public to role AIR_INDIA_AIRLINE_ROLE1;
grant usage on schema FLIGHT_DATABASE.public to role VISTARA_AIRLINE_ROLE1;
grant usage on schema FLIGHT_DATABASE.public to role GO_FIRST_AIRLINE_ROLE1;



create or replace masking policy flights_masks10 as (val float) returns float ->
case
when current_role() in ('SPICEJET_AIRLINE_ROLE1','VISTARA_AIRLINE_ROLE1','GO_FIRST_AIRLINE_ROLE1') then val*60*60
when current_role() in ('AIR_INDIA_AIRLINE_ROLE1','AIRASIA_AIRLINE_ROLE1') then val
end;


show masking policies like '%MASK%';

alter view flights_secure_view1 modify column duration set masking policy flights_masks10;

