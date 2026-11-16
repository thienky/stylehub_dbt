{% macro latest_rank(key='id') %}
row_number() over (
    partition by {{ key }}
    order by updated_at desc, _ingested_at desc
)
{% endmacro %}
