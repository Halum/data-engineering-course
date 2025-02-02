# Homework: Module-1

## Questions 3. Trip Segmentation Count

During the period of October 1st 2019 (inclusive) and November 1st 2019 (exclusive), how many trips, respectively, happened:

1. Up to 1 mile

```sql
select count(1) from green_trips 
where trip_distance <= 1;
```

**Result:**

| count |
|-------------|
| 104838 |
||

2. In between 1 (exclusive) and 3 miles (inclusive)

```sql
select count(1) from green_trips 
where trip_distance > 1 and trip_distance <= 3;
```

**Result:**

| count |
|-------------|
| 199013 |
||

3. In between 3 (exclusive) and 7 miles (inclusive)

```sql
select count(1) from green_trips 
where trip_distance > 3 and trip_distance <= 7;
```

**Result:**

| count |
|-------------|
| 109645 |
||

4. In between 7 (exclusive) and 10 miles (inclusive)

```sql
select count(1) from green_trips 
where trip_distance > 7 and trip_distance <= 10;
```
**Result:**

| count |
|-------------|
| 27688 |
||

5. Over 10 miles

```sql
select count(1) from green_trips 
where trip_distance > 10;
```

**Result:**

| count |
|-------------|
| 35205 |
||


## Question 4. Longest trip for each day
Which was the pick up day with the longest trip distance? Use the pick up time for your calculations.

Tip: For every day, we only care about one single trip with the longest distance.

```sql
select 
	lpep_dropoff_datetime - lpep_pickup_datetime as duration,
	lpep_pickup_datetime as pickup_date,
	lpep_dropoff_datetime as drop_date
from green_trips
where lpep_pickup_datetime::date in ('2019-10-11', '2019-10-24', '2019-10-26', '2019-10-31')
order by duration desc
limit 1;

```

**Result:**

| duration | pickup_date | drop_date |
|-------------|-------------|-------------|
| 23:59:47 | 2019-10-11 09:59:33 | 2019-10-12 09:59:20 |
|

## Question 5. Three biggest pickup zones
Which were the top pickup locations with over 13,000 in total_amount (across all trips) for 2019-10-18?

Consider only lpep_pickup_datetime when filtering by date.

* East Harlem North, East Harlem South, Morningside Heights
* East Harlem North, Morningside Heights
* Morningside Heights, Astoria Park, East Harlem South
* Bedford, East Harlem North, Astoria Park

```sql
select z."Zone", sum(gt.total_amount) as total_amount_a_day
from green_trips gt
join zones z
	on gt."PULocationID" = z."LocationID"
where 
	lpep_pickup_datetime::date = '2019-10-18'
group by z."Zone"
having sum(gt.total_amount) > 13000;
```

**Result:**

| Zone                | total_amount_a_day |
|---------------------|--------------------|
| East Harlem North   | 18686.68           |
| East Harlem South   | 16797.26           |
| Morningside Heights | 13029.79           |
|

## Question 6. Largest tip
For the passengers picked up in October 2019 in the zone named "East Harlem North" which was the drop off zone that had the largest tip?

Note: it's tip , not trip

We need the name of the zone, not the ID.

* Yorkville West
* JFK Airport
* East Harlem North
* East Harlem South

```sql
select zd."Zone", gt.tip_amount
from green_trips gt
join zones zp
	on gt."PULocationID" = zp."LocationID"
join zones zd
	on gt."DOLocationID" = zd."LocationID"
where extract(year from lpep_pickup_datetime) = 2019
  and extract(month from lpep_pickup_datetime) = 10
  and zp."Zone" = 'East Harlem North'
order by tip_amount desc
limit 1;
```

**Result:**

| Zone              |
|-------------------|
| East Harlem North |
|