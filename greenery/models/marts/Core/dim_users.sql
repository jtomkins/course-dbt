{{
  config(
    materialized='table'
  )
}}

SELECT
  u.user_guid,
  u.email,
  u.first_name,
  u.last_name,
  u.phone_number,
  u.created_at_utc,
  u.updated_at_utc,
  a.street_address,
  a.state,
  a.country,
  a.zip_code
  FROM {{ ref('stg_greenery__users') }} u
LEFT JOIN {{ ref('stg_greenery__addresses') }} a
  ON u.address_guid = a.address_guid