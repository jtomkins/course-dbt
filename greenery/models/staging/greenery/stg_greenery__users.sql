{{
  config(
    materialized='view'
  )
}}

with users_source as (
  select * from  {{ source('src_greenery', 'users') }}
)

, renamed_recast as (
    SELECT 
      user_id as user_guid,
      first_name,
      last_name,
      email,
      phone_number,
      created_at as created_at_utc,
      updated_at as updated_at_utc,
      address_id as address_guid
    FROM users_source
)

select * from renamed_recast