{{ config(materialized = 'table')  }}

SELECT
    session_guid
    ,created_at_utc
    ,user_guid
    ,sum(case when event_type = 'page_view' then 1 else 0 end) as page_view
    ,sum(case when event_type = 'checkout' then 1 else 0 end) as checkout
    ,sum(case when event_type = 'add_to_card' then 1 else 0 end) as add_to_cart
	,sum(case when event_type = 'package_shipped' then 1 else 0 end) as package_shipped
from {{ ref ('stg_greenery__events') }}
group by 1,2,3