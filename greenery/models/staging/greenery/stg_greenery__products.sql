{{
  config(
    materialized='view'
  )
}}

with products_source as (
  select * from {{ source('src_greenery', 'products') }}
)


, renamed_recast AS
(SELECT 
  product_id as product_guid,
  name as product_name,
  price,
  inventory
FROM products_source
)

select * from renamed_recast