# Week 1 Questions and Answers

## How many users do we have?
> 130 <br>
```sql 
	select count(user_guid) 
	from dbt_jen_w.stg_greenery__users
```	 

## On average, how many orders do we receive per hour?
> 15 (15.0416666666666667)  <br>
```	sql 
	select avg(order_count) 
	from (  SELECT 	count(order_guid) order_count, 
			EXTRACT(HOUR FROM created_at_utc)
		from dbt_jen_w.stg_greenery__orders  
		group by EXTRACT(HOUR FROM created_at_utc)
		order by EXTRACT(HOUR FROM created_at_utc) desc ) Z
```	 

## On average, how long does an order take from being placed to being delivered?
> 3 days 21hours 24mins 11sec 803279ms   <br>
```	sql 
select avg(dt_diff)
	from (SELECT order_guid,
			created_at_utc, 
			delivered_at_utc, 
			(delivered_at_utc - created_at_utc) as dt_diff
		from dbt_jen_w.stg_greenery__orders  
		where delivered_at_utc is not null) Z
```	 

## How many users have only made one purchase? Two purchases? Three+ purchases?

> 25 users have made one purchase, 28 users have made 2 purchases and 71 users have made 3 or more purchases  <br>

```sql 
with orders_gt_3 as (
	select count(nbr_orders_per_guid)				as number_of_users,
		   nbr_orders_per_guid					as number_of_purchases
		from 
			(select user_guid,
				count(distinct(order_guid))		as nbr_orders_per_guid 
			from dbt_jen_w.stg_greenery__orders
			group by 1
			)Z
		where nbr_orders_per_guid >= 3
		group by 2),
	orders_lt_3 as (
		select	count(nbr_orders_per_guid)			as number_of_users, 
			nbr_orders_per_guid				as number_of_purchases
		from 
			(select user_guid,
				count(distinct(order_guid))		as nbr_orders_per_guid
				from dbt_jen_w.stg_greenery__orders
				group by 1
				)Z
		where nbr_orders_per_guid < 3
		group by 2) 
	select number_of_users, number_of_purchases::varchar(255) as number_of_purchases from orders_lt_3
	union
	select sum(number_of_users) as number_of_users, '3 or more' as number_of_purchases from orders_gt_3
```

## On average, how many unique sessions do we have per hour?
> 16.3275862068965517  <br>

```sql	 
select avg(session_count)
	from (SELECT count(distinct(session_guid)) session_count, 
		 date_trunc('hour',  created_at_utc) as hour
		from dbt_jen_w.stg_greenery__events 
		group by 2
		order by 2 desc )z
```	 
