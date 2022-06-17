{{ config (materialized='table')}}

--time order placed to be delivered
with order_length as (
    select 
        order_guid
        ,delivered_at_utc
        ,created_at_utc
        ,estimated_delivery_at_utc
        ,(delivered_at_utc - created_at_utc)                as number_of_days_to_deliver
        , (delivered_at_utc - estimated_delivery_at_utc )   as diff_in_estimated_delivery
    from {{ ref('stg_greenery__orders')}}
)

SELECT
    int_orders_promo_id_agg.order_guid
    ,int_orders_promo_id_agg.instruction_set
    ,int_orders_promo_id_agg.digitized
    ,int_orders_promo_id_agg.mandatory
	,int_orders_promo_id_agg.optional
    ,int_orders_promo_id_agg.leverage
    ,int_orders_promo_id_agg.task_force
    ,order_length.delivered_at_utc
    ,order_length.created_at_utc
    ,order_length.estimated_delivery_at_utc
    ,order_length.number_of_days_to_deliver
    ,order_length.diff_in_estimated_delivery

from {{  ref('int_orders_promo_id_agg')  }}
left join order_length
    on int_orders_promo_id_agg.order_guid = order_length.order_guid