{{
  config(
    materialized='view'
  )
}}

with orders_source as (
  select * from {{ source('src_greenery', 'orders') }}
)


, renamed_recast AS
(SELECT 
    order_id as order_guid,
   replace(replace(lower(promo_id), '-', '_'), ' ', '_') as promo_id,
    user_id as user_guid,
    address_id as address_guid,
    created_at as created_at_utc,
    order_cost,
    shipping_cost,
    order_total,
    tracking_id,
    shipping_service,
    estimated_delivery_at as estimated_delivery_at_utc,
    delivered_at as delivered_at_utc,
    status
FROM orders_source
)

select * from renamed_recast