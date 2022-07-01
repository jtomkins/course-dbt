{{ config(materialized = 'table')  }}


With events_stats as (
select
  user_guid,
  session_guid,
  count(distinct session_guid) total_user_sessions,
  count(distinct product_guid ) total_unique_products_sampled,
  count(distinct order_guid ) filter (where checkout > 0)  as total_orders_with_checkouts,
  count(distinct session_guid ) filter (where checkout > 0) as sessions_with_checkouts,
	count(distinct session_guid ) filter (where package_shipped > 0) as sessions_with_shipment,
	count(distinct session_guid ) filter (where add_to_cart > 0) as sessions_with_add_to_cart,
  count(distinct session_guid ) filter (where page_view > 0) as session_with_page_views,
  sum(add_to_cart) as total_add_to_cart,
	sum(page_view) as total_page_views,
	sum(checkout ) as total_checkouts
from {{ ref('int_session_events_agg') }}
group by 1,2
)

select * from events_stats
