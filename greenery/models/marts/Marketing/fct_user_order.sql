{{ config (materialized='table')}}


SELECT
    stg_greenery__users.user_guid
    ,stg_greenery__users.first_name
    ,stg_greenery__users.last_name
    ,stg_greenery__users.email
    ,stg_greenery__users.phone_number
    ,stg_greenery__users.created_at_utc
    ,stg_greenery__users.updated_at_utc
    ,int_orders_promo_id_agg.order_guid
    ,int_orders_promo_id_agg.instruction_set
    ,int_orders_promo_id_agg.digitized
    ,int_orders_promo_id_agg.mandatory
	,int_orders_promo_id_agg.optional
    ,int_orders_promo_id_agg.leverage
    ,int_orders_promo_id_agg.task_force
    ,int_orders_delivery_basic.number_of_days_to_deliver
    ,int_orders_delivery_basic.diff_in_estimated_delivery
    
    
from {{  ref('int_orders_promo_id_agg')  }}
left join {{  ref('int_orders_delivery_basic')  }}
    on int_orders_promo_id_agg.order_guid = int_orders_delivery_basic.order_guid
left join {{  ref('stg_greenery__users')  }}
    on  int_orders_promo_id_agg.user_guid = stg_greenery__users.user_guid