{{ config (materialized='table')}}

with number_of_products_sold_per_order as (

            select  order_guid, p.product_guid, sum(quantity) as number_sold_per_order, product_name
            from dbt_jen_w.stg_greenery__order_items oi
            left outer join dbt_jen_w.stg_greenery__products p
                    on oi.product_guid = p.product_guid
            group by order_guid, p.product_guid, quantity, product_name
            order by order_guid
)

select * from number_of_products_sold_per_order