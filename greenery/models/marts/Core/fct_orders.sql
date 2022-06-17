{{ config (materialized='table')}}


SELECT
stg_greenery__orders.order_guid,
  stg_greenery__orders.created_at_utc,
  stg_greenery__orders.order_total,
  stg_greenery__orders.promo_id,
  pc.discount AS promo_code_discount,
  stg_greenery__orders.user_guid,
  u.first_name AS user_first_name,
  u.last_name AS user_last_name,
  stg_greenery__orders.address_guid,
  int_orders_delivery_basic.number_of_days_to_deliver,
  int_orders_delivery_basic.diff_in_estimated_delivery
from {{  ref('int_orders_delivery_basic')  }}
left join {{  ref('stg_greenery__orders')  }}
 on int_orders_delivery_basic.order_guid = stg_greenery__orders.order_guid 
LEFT JOIN {{ ref('stg_greenery__promos') }} pc
  ON stg_greenery__orders.promo_id = pc.promo_id
LEFT JOIN {{ ref('stg_greenery__users') }} u
  ON stg_greenery__orders.user_guid = u.user_guid