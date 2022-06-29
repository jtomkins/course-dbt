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
