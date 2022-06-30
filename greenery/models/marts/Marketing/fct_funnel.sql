{{ config (materialized='table')}}



SELECT  user_guid,
        session_guid,
        total_unique_products_sampled as total_unique_products,
        user_sessions_with_checkouts  as session_has_checkout,
	    user_sessions_with_shipment   as session_has_shipment,
	    user_sessions_with_add_to_cart as session_has_add_to_cart,
        number_of_unique_session_page_views as session_has_page_view
        --user_sessions_with_add_to_cart::numeric /  number_of_unique_session_page_views::numeric as land_and_add_funnel,
        --user_sessions_with_checkouts::numeric / user_sessions_with_add_to_cart::numeric      -- add to purchase funnel
from {{  ref('int_user_session_event_stats')  }}