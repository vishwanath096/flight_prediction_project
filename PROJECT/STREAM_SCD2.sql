----created a stream-----
create or replace stream flights_stream on table flights_table;


create or replace table flights_consumer_table(
SSN INT,
AIR_LINE VARCHAR,
FLIGHT STRING,
SOURCE_CITY VARCHAR,
DEPARTURE_TIME VARCHAR,
STOPS VARCHAR,
ARRIVAL_TIME VARCHAR,
destination_city VARCHAR,
CLASS VARCHAR,
DURATION FLOAT,
DAYS_LEFT INT,
PRICE INT,
stream_type string default null,
rec_version number default 0,
REC_DATE TIMESTAMP_LTZ);



CREATE OR REPLACE TASK flights_task2
  WAREHOUSE = compute_wh
  after flights_task1
WHEN
  SYSTEM$STREAM_HAS_DATA('flights_stream')
AS
merge into flights_consumer_table fct
using flights_stream fs 
on fct.ssn=fs.ssn and (metadata$action='DELETE')
when matched and metadata$isupdate='FALSE' then update set rec_version=9999, stream_type='DELETE'
when matched and metadata$isupdate='TRUE' then update set rec_version=rec_version-1, stream_type='DELETE'
when not matched then insert  (SSN,AIR_LINE,FLIGHT,SOURCE_CITY,DEPARTURE_TIME,STOPS,ARRIVAL_TIME,destination_city,CLASS,DURATION,DAYS_LEFT,PRICE,stream_type,rec_version,REC_DATE) 
values(fs.ssn,AIR_LINE,fs.FLIGHT,fs.SOURCE_CITY,fs.DEPARTURE_TIME,fs.STOPS,fs.ARRIVAL_TIME,fs.destination_city,fs.CLASS,fs.DURATION,fs.DAYS_LEFT,fs.PRICE,metadata$action,0,CURRENT_TIMESTAMP());

select * from flights_stream;
select * from flights_consumer_table;