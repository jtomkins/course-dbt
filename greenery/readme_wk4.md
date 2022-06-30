Part 1. dbt Snapshots
{% snapshot orders_snapshot %}

  {{
    config(
      target_schema='snapshots',
      strategy='check',
      unique_key='order_id',
      check_cols=['status'],
    )
  }}

  SELECT * FROM {{ source('src_greenery', 'orders') }}

{% endsnapshot %}

select * 
from  snapshots.orders_snapshot
WHERE order_id in ('05202733-0e17-4726-97c2-0520c024ab85', '914b8929-e04a-40f8-86ee-357f2be3a2a2');

Part 2. Modeling challenge

How are our users moving through the product funnel?

Which steps in the funnel have largest drop off points?


WITH agg AS ( 
select 
    count(distinct(session_guid))
    ,count(distinct case when page_view > 0 then session_guid end) as page_views 
    ,count(distinct case when add_to_cart > 0 then session_guid end) as add_to_cart
    ,count(distinct case when checkout > 0 then session_guid end) as checkout
    --,session_guid
    --,sum(page_view)
    --, page_view as has_page_view
from dbt_jen_w.fct_sessions
--group by 5 --,6
--order by 5
)
SELECT
  add_to_cart::numeric/page_views::numeric
  ,checkout::numeric/add_to_cart::numeric
  --,has_page_view
from agg  

