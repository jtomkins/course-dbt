{{ config(materialized = 'table')  }}

{% 
    set promo_ids = dbt_utils.get_column_values(
        table=ref('stg_greenery__orders'),
        column='promo_id'
    ) 
%}


SELECT
     order_guid
    ,user_guid
    ,address_guid
    ,created_at_utc
{% for promo in promo_ids %}
  , {{aggregate_promos( promo )}} AS {{promo}}
{% endfor %}
from {{ ref ('stg_greenery__orders') }}
group by 1,2,3,4