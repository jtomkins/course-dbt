{{ config (materialized='table')}}


SELECT
    stg_greenery__users.first_name
    ,stg_greenery__users.last_name
    ,stg_greenery__users.email
    ,stg_greenery__users.phone_number
    ,stg_greenery__users.created_at_utc users_created_at_utc
    ,stg_greenery__users.updated_at_utc users_updated_at_utc
    ,stg_greenery__addresses.street_address
    ,stg_greenery__addresses.state
    ,stg_greenery__addresses.country
    ,stg_greenery__addresses.zip_code
 ,int_products_sold_per_order.product_name  as product_name
  ,int_products_sold_per_order.number_sold_per_order
    ,int_orders_promo_id_agg.*

from {{  ref('int_orders_promo_id_agg')  }}
left join {{  ref('int_orders_delivery_basic')  }}
    on int_orders_promo_id_agg.order_guid = int_orders_delivery_basic.order_guid
left join {{  ref('stg_greenery__users')  }}
    on  int_orders_promo_id_agg.user_guid = stg_greenery__users.user_guid
LEFT JOIN {{ ref('stg_greenery__addresses') }}
  ON stg_greenery__users.address_guid =stg_greenery__addresses.address_guid
LEFT JOIN {{ ref('int_products_sold_per_order')}}
  ON int_products_sold_per_order.order_guid = int_orders_promo_id_agg.order_guid
  