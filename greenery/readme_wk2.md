# Week 3 Questions and Answers

## What is our overall conversion rate?
> note: conversion rate is defined as the # of unique sessions with a purchase event / total number of unique sessions. 
> 0.6245674740484429 <br>
```sql 
	select  sum(user_sessions_with_checkouts)::float / sum(number_of_unique_session_page_views)::float as conversion_rate
	from dbt_jen_w.int_user_session_event_stats
```	 

## What is our conversion rate by product?
> note: Conversion rate by product is defined as the # of unique sessions with a purchase event of that product / total number of unique sessions that viewed that product
> 15 (15.0416666666666667)  <br>
```	sql 
SELECT
  itps.product_name,
    (ioses.unique_user_sessions_with_checkouts::float 
        / ioses.unique_session_viewed_each_product::float) as checkout_product_conversion_rate
from {{  ref('int_product_session_event_stats')  }} as ioses
left join {{  ref('int_total_products_sold')  }} as itps
    on ioses.ordered_product_guid = itps.product_guid
```	 

## On average, how long does an order take from being placed to being delivered?
| Product ID | Product Name | Conversion Rate (%) |
| ----------- | ----------- | ----------- |
| fb0e8be7-5ac4-4a76-a1fa-2cc4bf0b2d80 | String of pearls | 60 |
| 74aeb414-e3dd-4e8a-beef-0fa45225214d | Arrow Head | 55 |
| c17e63f7-0d28-4a95-8248-b01ea354840e | Cactus | 54 |
| 689fb64e-a4a2-45c5-b9f2-480c2155624d | Bamboo | 53 |
| b66a7143-c18a-43bb-b5dc-06bb5d1d3160 | ZZ Plant | 53 |
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
