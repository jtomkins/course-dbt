with orders_cohort as (
select user_guid 
,count (distinct order_guid)as user_orders
from dbt_jen_w.stg_greenery__orders
group by 1)
,user_bucket as (
  select user_guid
  ,(user_orders = 1) ::int as has_one_purchases
  ,(user_orders >=2)::int as has_two_purchases
  ,(user_orders >=3)::int as has_three_purchases
  from orders_cohort
)
select sum(has_two_purchases)::float
  / count(distinct user_guid)::float as repeat_rate
from user_bucket;