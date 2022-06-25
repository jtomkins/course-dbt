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
| fb0e8be7-5ac4-4a76-a1fa-2cc4bf0b2d80 | String of pearls |60.937 |
| 74aeb414-e3dd-4e8a-beef-0fa45225214d | Arrow Head |55.555 |
| c17e63f7-0d28-4a95-8248-b01ea354840e | Cactus |54.545 |
| b66a7143-c18a-43bb-b5dc-06bb5d1d3160 | ZZ Plant |53.968 |
| 689fb64e-a4a2-45c5-b9f2-480c2155624d | Bamboo |53.7313|
| 579f4cd0-1f45-49d2-af55-9ab2b72c3b35 | Rubber Plant |51.851
| be49171b-9f72-4fc9-bf7a-9a52e259836b | Monstera |51.020|
| b86ae24b-6f59-47e8-8adc-b17d88cbd367 | Calathea Makoyana |50.943|
| e706ab70-b396-4d30-a6b2-a1ccf3625b52 | Fiddle Leaf Fig |50|
| 5ceddd13-cf00-481f-9285-8340ab95d06d | Majesty Palm |49.253|

```	sql 
SELECT
  itps.product_guid,
  itps.product_name,
  (ioses.unique_user_sessions_with_checkouts::float 
        / ioses.unique_session_viewed_each_product::float)*100 as checkout_product_conversion_rate
from dbt_jen_w.int_product_session_event_stats as ioses
left join dbt_jen_w.int_total_products_sold as itps
    on ioses.ordered_product_guid = itps.product_guid
order by 3 desc
limit 10
```	 

