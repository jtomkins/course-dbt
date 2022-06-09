{{
  config(
    materialized='view'
  )
}}

with promos_source as (
  select * from {{ source('src_greenery', 'promos') }}
)

, renamed_recast AS
(SELECT 
  promo_id,
  discount,
  status
FROM promos_source
)

select * from renamed_recast