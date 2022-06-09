{{
  config(
    materialized='view'
  )
}}

with superheros_source as (
  select * from {{ source('src_greenery', 'superheroes') }}
)


, renamed_recast AS
(SELECT 
    id AS superhero_id,
    name,
    gender,
    eye_color,
    race,
    hair_color,
    NULLIF(height, -99) AS height,
    publisher,
    skin_color,
    alignment,
    NULLIF(weight, -99) AS weight_lbs,
    {{ lbs_to_kgs('weight') }} AS weight_kg
FROM superheros_source
)

select * from renamed_recast