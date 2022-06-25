set hive.strict.checks.cartesian.product=false;
create table if not exists nyc_taxi (vendor_id string, pickup_datetime string, dropoff_datetime string, passenger_count int, trip_distance double, pickup_longitude double, pickup_latitude double, rate_code int, store_and_fwd_flag string, dropoff_longitude double, dropoff_latitude double, payment_type string, fare_amount double, surcharge double, mta_tax double, tip_amount double, tolls_amount double, total_amount double)
row format delimited
fields terminated by ','
stored as textfile
tblproperties('skip.header.line.count' = '1');
load data local inpath '/mnt/nyc_taxi_data_2014.csv' overwrite into table nyc_taxi;
create view if not exists nyc1 as
select * from nyc_taxi
where vendor_id is not null and pickup_datetime is not null and dropoff_datetime is not null and passenger_count is not null and trip_distance is not null and pickup_longitude is not null and pickup_latitude is not null and rate_code is not null and store_and_fwd_flag is not null and dropoff_longitude is not null and dropoff_latitude is not null and payment_type is not null and fare_amount is not null and surcharge is not null and mta_tax is not null and tip_amount is not null and tolls_amount is not null and total_amount is not null;
Select nyc1.*, sqrt(pow(nyc1.tip_amount-b.tip_amount, 2) + pow(nyc1.trip_distance-b.trip_distance, 2) + pow(nyc1.fare_amount-b.fare_amount,2)) as dist from nyc1 ,(select tip_amount,trip_distance,fare_amount from nyc1 limit 1) as b 
order by dist limit 5;