# Week 3 Questions and Answers

## What is our overall conversion rate?
*note: conversion rate is defined as the # of unique sessions with a purchase event / total number of unique sessions.*
> 0.6245674740484429 <br>
```sql 
	select  sum(user_sessions_with_checkouts)::float / sum(number_of_unique_session_page_views)::float as conversion_rate
	from dbt_jen_w.int_user_session_event_stats
```	 

## What is our conversion rate by product?
*note: Conversion rate by product is defined as the # of unique sessions with a purchase event of that product / total number of unique sessions that viewed that product*
| Product ID | Product Name | Conversion Rate(%) |
| ----------- | ----------- | ----------- |
| fb0e8be7-5ac4-4a76-a1fa-2cc4bf0b2d80 | String of pearls 60.937 |
| 74aeb414-e3dd-4e8a-beef-0fa45225214d | Arrow Head |55.555 |
| c17e63f7-0d28-4a95-8248-b01ea354840e | Cactus |54.545 |
| b66a7143-c18a-43bb-b5dc-06bb5d1d3160 | ZZ Plant |53.968 |
| 689fb64e-a4a2-45c5-b9f2-480c2155624d | Bamboo |53.7313|
| 689fb64e-a4a2-45c5-b9f2-480c2155624d | Rubber Plant |51.851
| 689fb64e-a4a2-45c5-b9f2-480c2155624d | Monstera |51.020|
| 689fb64e-a4a2-45c5-b9f2-480c2155624d | Calathea Makoyana |50.943|
| 689fb64e-a4a2-45c5-b9f2-480c2155624d | Fiddle Leaf Fig |50|
| 689fb64e-a4a2-45c5-b9f2-480c2155624d | Majesty Palm |49.253|

```	sql 
SELECT
  itps.product_name,
    (ioses.unique_user_sessions_with_checkouts::float 
        / ioses.unique_session_viewed_each_product::float) as checkout_product_conversion_rate
from {{  ref('int_product_session_event_stats')  }} as ioses
left join {{  ref('int_total_products_sold')  }} as itps
    on ioses.ordered_product_guid = itps.product_guid
```	 

