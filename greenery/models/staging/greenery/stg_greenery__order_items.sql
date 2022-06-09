{{
  config(
    materialized='view'
  )
}}

with order_items_source as (
  select * from  {{ source('src_greenery', 'order_items') }}
)


, renamed_recast AS
(SELECT 
  order_id as order_guid,
  product_id as product_guid,
  quantity
FROM order_items_source
)

select * from renamed_recast