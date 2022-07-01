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

Product funnel: Sessions with any event of type page_view --> add_to_cart --> checkout

New model: /Marketing/fct_user_session_event_stats

How are our users moving through the product funnel?
select 
    SUM(session_with_page_views) count_page_views,
    SUM(sessions_with_add_to_cart) count_add_to_cart,
    SUM(sessions_with_checkouts) count_checkouts
from dbt_jen_w.fct_user_session_event_stats


Which steps in the funnel have largest drop off points?

With sess_agg as (
SELECT  user_guid,
        session_guid,
        sessions_with_checkouts, 
	      sessions_with_add_to_cart,
	      session_with_page_views
from dbt_jen_w.fct_user_session_event_stats
)
SELECT
    sum( sessions_with_add_to_cart::numeric)/sum(session_with_page_views::numeric) as cart,
    sum( sessions_with_checkouts::numeric) / sum(sessions_with_add_to_cart::numeric)  as page_view
from sess_agg  


Exposure: /models/exposures.yml
version: 2

exposures:  
  - name: Product Funnel Dashboard
    description: >
      Core model for the product funnel dashboard.
    type: dashboard
    owner:
      name: Jen Walker
      email: jtomkins@ucsc.edu
    depends_on:
      - ref('fct_user_session_event_stats')


Part 3 reflection

