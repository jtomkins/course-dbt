# Week 1 Questions and Answers

## How many users do we have?
> 130 <br>
```	 
	select count(user_id) 
	from dbt_jen_w.dbt_jen_w.stg_greenery__users
```	 

## On average, how many orders do we receive per hour?
> 15 (15.0416666666666667)  <br>
```	 
	select avg(order_count) 
	from (  SELECT 	count(order_id) order_count, 
			EXTRACT(HOUR FROM created_at)
		from dbt_jen_w.stg_greenery__orders 
		group by EXTRACT(HOUR FROM created_at)
		order by EXTRACT(HOUR FROM created_at) desc ) Z
```	 

## On average, how long does an order take from being placed to being delivered?
> 3 days 21hours 24mins 11sec 803279ms   <br>
```	 
select avg(dt_diff)
	from (SELECT 	order_id,
			created_at, 
			delivered_at, 
			(delivered_at - created_at) as dt_diff
		from dbt_jen_w.stg_greenery__orders  
		where delivered_at is not null) Z
```	 

## How many users have only made one purchase? Two purchases? Three+ purchases?

> 25 users have made one purchase, 28 users have made 2 purchases and 71 users have made 3 or more purchases  <br>

```	 
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
148.0416666666666667  <br>

-- (not sure how to derive, but checked that there are no duplicate session ids in the data) <br>
```	 
	select avg(session_count)
	from (SELECT count(session_id) session_count, 
			EXTRACT(HOUR FROM created_at) as hour
		from dbt_jen_w.stg_greenery__events 
		group by EXTRACT(HOUR FROM created_at)
		order by EXTRACT(HOUR FROM created_at) desc ) Z
```	 
