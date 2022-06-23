{{ config(materialized = 'table')  }}

{%
    set event_types = dbt_utils.get_query_results_as_dict (
            "select distinct quote_literal(event_type) as event_type, event_type as column_name from"
            ~ ref('stg_greenery__events')
    )
%}

With events_agg as (
SELECT
    session_guid
    ,created_at_utc
    ,user_guid
    ,product_guid
    ,order_guid
     {% for event_type in event_types['event_type'] %}
        ,sum(case when event_type = {{event_type}} then 1 else 0 end) as {{ event_types['column_name'][loop.index0] }}
    {% endfor %}
from {{ ref('stg_greenery__events') }}
group by 1,2,3,4,5
)

select * from events_agg