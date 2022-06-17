{{ config(materialized = 'table')  }}


SELECT
     order_guid
    ,user_guid
    ,address_guid
    ,created_at_utc
    ,sum(case when promo_id = 'instruction set' then 1 else 0 end) as instruction_set
    ,sum(case when promo_id = 'digitized' then 1 else 0 end) as digitized
    ,sum(case when promo_id = 'mandatory' then 1 else 0 end) as mandatory
	,sum(case when promo_id = 'optional' then 1 else 0 end) as optional
    ,sum(case when promo_id = 'leverage' then 1 else 0 end) as leverage
    ,sum(case when promo_id = 'task_force' then 1 else 0 end) as task_force
from {{ ref ('stg_greenery__orders') }}
group by 1,2,3,4