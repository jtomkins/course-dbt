{% macro aggregate_promos(promo_id) %}
    SUM(CASE WHEN promo_id = '{{promo_id}}' THEN 1 ELSE 0 END)
{% endmacro %}