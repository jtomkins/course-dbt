{{
  config(
    materialized='view'
  )
}}

with events_source as (
  select * from  {{ source('src_greenery', 'events') }}
)


, renamed_recast AS
(SELECT 
    event_id as event_guid,
    session_id as session_guid,
    user_id as user_guid,
    event_type,
    page_url,
    created_at as created_at_utc,
    order_id as order_guid,
    product_id as product_guid
FROM events_source)

select * from renamed_recast
