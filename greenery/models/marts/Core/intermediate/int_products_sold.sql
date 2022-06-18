{{ config (materialized='table')}}

--time order placed to be delivered
with number_of_products_sold as (
    select oi.product_guid, count(oi.product_guid) number_sold,  p.product_name
    from dbt_jen_w.stg_greenery__order_items oi
    left outer join dbt_jen_w.stg_greenery__products p
        on oi.product_guid = p.product_guid
    group by oi.product_guid, p.product_name
)

select * from number_of_products_sold
