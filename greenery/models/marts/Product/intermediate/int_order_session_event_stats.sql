{{ config(materialized = 'table')  }}


with session_by_product  as (
    select product_guid as sbp_product_guid,
            count(distinct session_guid) filter (where page_view > 0) as unique_session_viewed_each_product,
            count(distinct session_guid) filter (where add_to_cart > 0) as unique_user_sessions_with_add_to_cart
 from dbt_jen_w.int_session_events_agg_macro
    where product_guid is not null
    --and page_view > 0
    group by 1
    order by 1
), order_events_stats as (
select 
  o.product_guid as oes_product_guid,
  o.product_name as oes_product_name,
  count(distinct  session_guid ) filter (where checkout > 0) as unique_user_sessions_with_checkouts
  from {{ ref('int_session_events_agg_macro') }} m
    inner join {{ ref('int_products_sold_per_order') }} o
      on m.order_guid = o.order_guid
and checkout > 0
  group by 1,2
)
select sbp.*, 
      oes.*, 
      (unique_user_sessions_with_checkouts::float/ unique_session_viewed_each_product::float) as _checkout_product_conversion_rate,
      (unique_user_sessions_with_add_to_cart::float/ unique_session_viewed_each_product::float) as _add_to_cart_product_conversion_rate
from session_by_product sbp
    left join order_events_stats oes
    on sbp.sbp_product_guid = oes.oes_product_guid
