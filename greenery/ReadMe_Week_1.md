# Week 1 Questions and Answers

## How many users do we have?
> 130 <br>
*`select count(user_id) from dbt_jen_w.stg_users`*

## On average, how many orders do we receive per hour?
> 15 (15.0416666666666667)  <br>
*`select avg(order_count) 
	from (SELECT count(order_id) order_count, EXTRACT(HOUR FROM created_at)
	from dbt_jen_w.stg_orders o 
	group by EXTRACT(HOUR FROM created_at)
	order by EXTRACT(HOUR FROM created_at) desc ) Z`*

## On average, how long does an order take from being placed to being delivered?
> 3 days 21hours 24mins 11sec 803279ms   <br>
*`select avg(dt_diff)
	from (SELECT order_id ,created_at, delivered_at, (delivered_at - created_at) as dt_diff
	from dbt_jen_w.stg_orders  
	where delivered_at is not null) Z`*


## How many users have only made one purchase? (Note: you should consider a purchase to be a single order. In other words, if a user places one order for 3 products, they are considered to have made 1 purchase.)
> 25
	*`select count(user_id)
	from (select user_id
			from dbt_jen_w.stg_orders
			group by user_id
			having count(*) = 1)Z`*

## Two purchases? 
> 28
	*`select count(user_id)
	from (select user_id
			from dbt_jen_w.stg_orders
			group by user_id
			having count(*) = 2)Z`*

## Three+ purchases?
> 71
	*`select count(user_id)
	from (select user_id
			from dbt_jen_w.stg_orders
			group by user_id
			having count(*) >= 3)Z`*

## On average, how many unique sessions do we have per hour?
148.0416666666666667

-- (not sure how to derive, but checked that there are no duplicate session ids in the data) <br>
	*`select avg(session_count)
	from (SELECT count(session_id) session_count, EXTRACT(HOUR FROM created_at) as hour
	from dbt_jen_w.stg_events 
	group by EXTRACT(HOUR FROM created_at)
	order by EXTRACT(HOUR FROM created_at) desc ) Z`*