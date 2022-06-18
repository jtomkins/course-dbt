{{
  config(
    materialized='table'
  )
}}

SELECT
  stg_greenery__products.product_guid
  ,stg_greenery__products.product_name
  ,stg_greenery__products.price
  ,stg_greenery__products.inventory
  ,int_products_sold.total_number_sold
  FROM {{ ref('stg_greenery__products') }} 
    Left join {{ ref('int_products_sold')}}
    on stg_greenery__products.product_guid = int_products_sold.product_guid 

