{{ config (materialized='table')}}

--time order placed to be delivered
with order_length as (
    select 
        order_guid
        ,(delivered_at_utc - created_at_utc)                as number_of_days_to_deliver
        , (delivered_at_utc - estimated_delivery_at_utc )   as diff_in_estimated_delivery
    from {{ ref('stg_greenery__orders')}}

)

select * from order_length