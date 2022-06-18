{{ config (materialized='table')}}

with total_number_of_products_sold as (
    select oi.product_guid, sum(oi.quantity) total_number_sold,  p.product_name
from {{ ref ('stg_greenery__order_items') }}  oi
left outer join {{ ref ('stg_greenery__products') }}  p
        on oi.product_guid = p.product_guid
    group by oi.product_guid, p.product_name
)

select * from total_number_of_products_sold
