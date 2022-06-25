{{ config (materialized='table')}}

-- Conversion rate by product is defined as the # of unique sessions with a purchase event 
-- of that product / total number of unique sessions that viewed that product
SELECT
itps.product_guid,
  itps.product_name,
  itps.total_number_sold,
  ioses.unique_user_sessions_with_checkouts,
  ioses.unique_user_sessions_with_add_to_cart,
  ioses.unique_session_viewed_each_product,
    (ioses.unique_user_sessions_with_checkouts::float 
        / ioses.unique_session_viewed_each_product::float) as checkout_product_conversion_rate,
      (ioses.unique_user_sessions_with_add_to_cart::float 
        / ioses.unique_session_viewed_each_product::float) as add_to_cart_product_conversion_rate
    
from {{  ref('int_product_session_event_stats')  }} as ioses
left join {{  ref('int_total_products_sold')  }} as itps
    on ioses.ordered_product_guid = itps.product_guid
order by 2 desc

