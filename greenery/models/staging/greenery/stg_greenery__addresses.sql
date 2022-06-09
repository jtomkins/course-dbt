{{
  config(
    materialized='view'
      ,unique_key = 'address_guid'
  )
}}

with addresses_source as (
  select * from {{ source('src_greenery', 'addresses') }}
)

, renamed_casted as 
(SELECT 
  address_id as address_guid,
  address as street_address, 
  lpad(zipcode::varchar, 5, '0') as zip_code,
  state, 
  country
FROM addresses_source
)

select * from renamed_casted