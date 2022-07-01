# Week 3 
## Part 1: dbt Snapshots
```sql 
{% snapshot orders_snapshot %}

  {{
    config(
      target_schema='snapshots',
      strategy='check',
      unique_key='order_id',
      check_cols=['status'],
    )
  }}

  SELECT * FROM {{ source('src_greenery', 'orders') }}

{% endsnapshot %}
```

## Part 2: Modeling challenge
**How are our users moving through the product funnel?**<br>
**Product funnel: Sessions with any event of type page_view --> add_to_cart --> checkout** <br>

>New model: /Marketing/fct_user_session_event_stats <br>
> 578 of users have viewed a page, 467 of users have the added-to-cart and 361 have checked out.
```sql 
select 
    SUM(session_with_page_views) count_page_views,
    SUM(sessions_with_add_to_cart) count_add_to_cart,
    SUM(sessions_with_checkouts) count_checkouts
from dbt_jen_w.fct_user_session_event_stats
```
**Which steps in the funnel have largest drop off points?** <br>
>Biggest drop off point is between add to cart and checkout.<br>
>The conversion rate for step 1 is 0.807. The conversion rate for step 2 is 0.773.
```sql 
With sess_agg as (
SELECT  user_guid,
        session_guid,
        sessions_with_checkouts, 
	      sessions_with_add_to_cart,
	      session_with_page_views
from dbt_jen_w.fct_user_session_event_stats
)
SELECT
    sum( sessions_with_add_to_cart::numeric)/sum(session_with_page_views::numeric) as cart,
    sum( sessions_with_checkouts::numeric) / sum(sessions_with_add_to_cart::numeric)  as page_view
from sess_agg  
```

>Exposure: /models/exposures.yml
```
version: 2

exposures:  
  - name: Product Funnel Dashboard
    description: >
      Core model for the product funnel dashboard.
    type: dashboard
    owner:
      name: Jen Walker
      email: jtomkins@ucsc.edu
    depends_on:
      - ref('fct_user_session_event_stats')
```

## Part 3:reflection
**3A. dbt next steps for you** <br>
**if your organization is using dbt, what are 1-2 things you might do differently / recommend to your organization based on learning from this course?** <br>
>Our organization is at the beginning stage of implmenting dbt, I would recommend to follow the best practices used for oganizing files, naming conventions and use of the dbt generated documentation.  I would also recommend the best practice of keeping the models simple, (dont over engineer), and also highlight that the BI tool is the layer that is used for the finalization and layout of the query results, not the fct/dim models.

