{{ config(materialized = 'table')  }}


with session_by_product  as (
    select product_guid as viewed_product_guid,
            count(distinct session_guid) filter (where page_view > 0) as unique_session_viewed_each_product,
            count(distinct session_guid) filter (where add_to_cart > 0) as unique_user_sessions_with_add_to_cart
 from dbt_jen_w.int_session_events_agg_macro
    where product_guid is not null
    group by 1
    order by 1
), 
order_events_stats as (
select 
  p.product_guid as ordered_product_guid,
  count(distinct  session_guid ) filter (where checkout > 0) as unique_user_sessions_with_checkouts
  from {{ ref('int_session_events_agg_macro') }} m
    inner join {{ ref('int_products_sold_per_order') }} p
      on m.order_guid = p.order_guid
and checkout > 0
  group by 1
)
select sbp.*, 
      oes.*
from session_by_product sbp
    left join order_events_stats oes
    on sbp.viewed_product_guid = oes.ordered_product_guid
