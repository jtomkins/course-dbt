{{ config (materialized='table')}}

with session_length as (
    select 
        session_guid
        ,min(created_at_utc) as first_event
        ,max(created_at_utc) as last_event
    from {{ ref('stg_greenery__events')}}
    group by 1
)

SELECT
    iseam.session_guid
    ,iseam.user_guid
    ,stu.first_name
    ,stu.last_name
    ,stu.email
    ,iseam.page_view
    ,iseam.add_to_cart
    ,iseam.checkout
    ,iseam.package_shipped
    ,sl.first_event as first_session_event
    ,sl.last_event as last_session_event
    ,date_part('hour', sl.last_event::timestamp - sl.first_event::timestamp) as hours_diff
from {{  ref('int_session_events_agg')  }} as iseam
left join {{  ref('stg_greenery__users')   }} as stu
    on iseam.user_guid = stu.user_guid
left join session_length sl
    on iseam.session_guid = sl.session_guid