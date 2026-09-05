{% macro payment_status_flag(payment_value_column) %}

case
    when {{ payment_value_column }} is null then true
    else false
end

{% endmacro %}