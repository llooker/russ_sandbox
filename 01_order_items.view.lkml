



view: order_items {

  sql_table_name: order_items ;; 
  
  parameter: stack_by { 
    type: unquoted
    allowed_value: {
  label: "Category"
  value: "Category"
  }
 allowed_value: {
  label: "Brand"
  value: "Brand"
  }
 allowed_value: {
  label: "Department"
  value: "Department"
  }
 allowed_value: {
  label: "State"
  value: "State"
  } 
  } 
  
  filter: cohort_by { 
    type: string
    hidden: yes
    suggestions: [
    "Week",
    "Month",
    "Quarter",
    "Year",
    ] 
  }
  
  filter: cpt_code { 
    type: string
    suggestable: no 
  }
  
  filter: metric { 
    type: string
    hidden: yes
    suggestions: [
    "Order Count",
    "Gross Margin",
    "Total Sales",
    "Unique Users",
    ] 
  } 
  
  dimension: cpt_code_value { 
    type: string
    sql: case when {% condition cpt_code %} '' {% endcondition %} then 0 else 1 end ;; 
  }
  
  dimension: created_week_html { 
    type: date_week
    sql: ${TABLE}.created_at ;;
    html: {{ value | date: "%s" | plus: 518400 | date: "%Y-%m-%d" }} ;; 
  }
  
  dimension: days_since_sold { 
    hidden: yes
    sql: datediff('day',${created_raw},CURRENT_DATE) ;; 
  }
  
  dimension: days_to_process { 
    type: number
    sql: CASE
        WHEN ${status} = 'Processing' THEN DATEDIFF('day',${created_raw},GETDATE())*1.0
        WHEN ${status} IN ('Shipped', 'Complete', 'Returned') THEN DATEDIFF('day',${created_raw},${shipped_raw})*1.0
        WHEN ${status} = 'Cancelled' THEN NULL
      END ;;
    html: {% if value > 2 %}
    <font color="darkgreen">{{ rendered_value }}</font>
    {% elsif value > 3 %}
    <font color="goldenrod">{{ rendered_value }}</font>
    {% else %}
    <font color="darkred">{{ rendered_value }}</font>
    {% endif %} ;; 
  }
  
  dimension: days_until_next_order { 
    type: number
    view_label: "Repeat Purchase Facts"
    sql: DATEDIFF('day',${created_raw},${repeat_purchase_facts.next_order_raw}) ;; 
  }
  
  dimension: gross_margin { 
    type: number
    value_format_name: usd
    sql: ${sale_price} - ${inventory_items.cost} ;; 
  }
  
  dimension: id { 
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
    tags: [
    "hello, World!",
    ] 
  }
  
  dimension: inventory_item_id { 
    type: number
    hidden: yes
    sql: ${TABLE}.inventory_item_id ;; 
  }
  
  dimension: is_returned { 
    type: yesno
    sql: ${returned_raw} IS NOT NULL ;; 
  }
  
  dimension: item_gross_margin_percentage { 
    type: number
    value_format_name: percent_2
    sql: 1.0 * ${gross_margin}/NULLIF(${sale_price},0) ;; 
  }
  
  dimension: item_gross_margin_percentage_tier { 
    type: tier
    sql: 100*${item_gross_margin_percentage} ;;
    tiers: [
      0, 10, 20, 30, 40, 50, 60, 70, 80, 90,
    ]
    style: interval 
  }
  
  dimension: months_since_signup { 
    view_label: "Orders"
    type: number
    sql: DATEDIFF('month',${users.created_raw},${created_raw}) ;; 
  }
  
  dimension: new_dimension { 
    type: string
    html: {% if order_items.stack_by._parameter_value == 'Brand' %} {{ products.brand._value }}
         {% elsif order_items.stack_by._parameter_value == 'Category' %}  {{ products.category._value }}
         {% elsif order_items.stack_by._parameter_value == 'Department' %} {{ products.department._value }}
         {% elsif order_items.stack_by._parameter_value == 'State' %} {{ users.state._value }}
         {% else %} 'N/A'
         {% endif %} ;;
    sql: {% if order_items.stack_by._parameter_value == 'Brand' %} products.brand
         {% elsif order_items.stack_by._parameter_value == 'Category' %}  products.category
         {% elsif order_items.stack_by._parameter_value == 'Department' %} products.department
         {% elsif order_items.stack_by._parameter_value == 'State' %} users.state
         {% else %} 'N/A'
         {% endif %} ;; 
  }
  
  dimension: order_id { 
    type: number
    sql: ${TABLE}.order_id ;;
    
action: {
  label: "Send this to slack channel"
  url: "https://hooks.zapier.com/hooks/catch/1662138/tvc3zj/"
  
param: {
  name: "user_dash_link"
  value: "https://demo.looker.com/dashboards/160?Email={{ users.email._value}}"
  }
  
form_param: {
  name: "Message"
  type: textarea
  }
form_param: {
  name: "Recipient"
  type: select
  default: "zevl"
  
option: {
  name: "zevl"
  label: "Zev"
  }
option: {
  name: "slackdemo"
  label: "Slack Demo User"
  }
  }
form_param: {
  name: "Channel"
  type: select
  default: "cs"
  
option: {
  name: "cs"
  label: "Customer Support"
  }
option: {
  name: "general"
  label: "General"
  }
  }
  } 
  }
  
  dimension: periods_as_customer { 
    type: number
    hidden: yes
    sql: DATEDIFF({% parameter cohort_by %}, ${user_order_facts.first_order_date}, ${user_order_facts.latest_order_date}) ;; 
  }
  
  dimension: repeat_orders_within_30d { 
    type: yesno
    view_label: "Repeat Purchase Facts"
    sql: ${days_until_next_order} <= 30 ;; 
  }
  
  dimension: reporting_period { 
    group_label: "Order Date"
    sql: CASE
        WHEN date_part('year',${created_raw}) = date_part('year',current_date)
        AND ${created_raw} < CURRENT_DATE
        THEN 'This Year to Date'

        WHEN date_part('year',${created_raw}) + 1 = date_part('year',current_date)
        AND date_part('dayofyear',${created_raw}) <= date_part('dayofyear',current_date)
        THEN 'Last Year to Date'
      END ;; 
  }
  
  dimension: sale_price { 
    type: number
    value_format_name: usd
    sql: ${TABLE}.sale_price ;; 
  }
  
  dimension: shipping_time { 
    type: number
    sql: datediff('day',${shipped_raw},${delivered_raw})*1.0 ;; 
  }
  
  dimension: status { 
    sql: ${TABLE}.status ;; 
  }
  
  dimension: user_id { 
    type: number
    hidden: yes
    sql: ${TABLE}.user_id ;; 
  } 
  
  dimension_group: created { 
    type: time
    timeframes: [
      time, hour, date, week, month, year, hour_of_day, day_of_week, month_num, raw, week_of_year,
    ]
    sql: ${TABLE}.created_at ;; 
  }
  
  dimension_group: delivered { 
    type: time
    timeframes: [
      date, week, month, raw,
    ]
    sql: ${TABLE}.delivered_at ;; 
  }
  
  dimension_group: first_order_period { 
    type: time
    timeframes: [
      date,
    ]
    hidden: yes
    sql: CAST(DATE_TRUNC({% parameter cohort_by %}, ${user_order_facts.first_order_date}) AS DATE) ;; 
  }
  
  dimension_group: returned { 
    type: time
    timeframes: [
      time, date, week, month, raw,
    ]
    sql: ${TABLE}.returned_at ;; 
  }
  
  dimension_group: shipped { 
    type: time
    timeframes: [
      date, week, month, raw,
    ]
    sql: ${TABLE}.shipped_at ;; 
  } 
  
  measure: 30_day_repeat_purchase_rate { 
    description: "The percentage of customers who purchase again within 30 days"
    view_label: "Repeat Purchase Facts"
    type: number
    value_format_name: percent_1
    sql: 1.0 * ${count_with_repeat_purchase_within_30d} / NULLIF(${count},0) ;;
    drill_fields: [
      products.brand, order_count, count_with_repeat_purchase_within_30d,
    ] 
  }
  
  measure: average_days_to_process { 
    type: average
    value_format_name: decimal_2
    sql: ${days_to_process} ;; 
  }
  
  measure: average_gross_margin { 
    type: average
    value_format_name: usd
    sql: ${gross_margin} ;;
    drill_fields: [
      detail*,
    ] 
  }
  
  measure: average_sale_price { 
    type: average
    value_format_name: usd
    sql: ${sale_price} ;;
    drill_fields: [
      detail*,
    ] 
  }
  
  measure: average_shipping_time { 
    type: average
    value_format_name: decimal_2
    sql: ${shipping_time} ;; 
  }
  
  measure: average_spend_per_user { 
    type: number
    value_format_name: usd
    sql: 1.0 * ${total_sale_price} / NULLIF(${users.count},0) ;;
    drill_fields: [
      detail*,
    ] 
  }
  
  measure: cohort_values_0 { 
    type: count_distinct
    hidden: yes
    sql: CASE WHEN {% parameter metric %} = 'Order Count' THEN ${id}
        WHEN {% parameter metric %} = 'Unique Users' THEN ${users.id}
        ELSE null
      END ;; 
  }
  
  measure: cohort_values_1 { 
    type: sum
    hidden: yes
    sql: CASE WHEN {% parameter metric %} = 'Gross Margin' THEN ${gross_margin}
        WHEN {% parameter metric %} = 'Total Sales' THEN ${sale_price}
        ELSE 0
      END ;; 
  }
  
  measure: count { 
    type: count_distinct
    sql: ${id} ;;
    drill_fields: [
      detail*,
    ] 
  }
  
  measure: count_last_28d { 
    label: "Count Sold in Trailing 28 Days"
    type: count_distinct
    sql: ${id} ;;
    hidden: yes
    
filters: {
  field: created_date
  value: "28 days"
  } 
  }
  
  measure: count_with_repeat_purchase_within_30d { 
    type: count_distinct
    sql: ${id} ;;
    view_label: "Repeat Purchase Facts"
    
filters: {
  field: repeat_orders_within_30d
  value: "Yes"
  } 
  }
  
  measure: first_purchase_count { 
    view_label: "Orders"
    type: count_distinct
    sql: ${order_id} ;;
    
filters: {
  field: order_facts.is_first_purchase
  value: "Yes"
  }
    drill_fields: [
      user_id, order_id, created_date, users.traffic_source,
    ] 
  }
  
  measure: max_sale_price { 
    type: max
    sql: ${sale_price} ;; 
  }
  
  measure: median_sale_price { 
    type: median
    value_format_name: usd
    sql: ${sale_price} ;;
    drill_fields: [
      detail*,
    ] 
  }
  
  measure: min_sale_price { 
    type: min
    sql: ${sale_price} ;; 
  }
  
  measure: order_count { 
    view_label: "Orders"
    type: count_distinct
    drill_fields: [
      detail*,
    ]
    sql: ${order_id} ;; 
  }
  
  measure: return_rate { 
    type: number
    value_format_name: percent_2
    sql: 1.0 * ${returned_count} / nullif(${count},0) ;; 
  }
  
  measure: returned_count { 
    type: count_distinct
    sql: ${id} ;;
    
filters: {
  field: is_returned
  value: "yes"
  }
    drill_fields: [
      detail*,
    ] 
  }
  
  measure: returned_total_sale_price { 
    type: sum
    value_format_name: usd
    sql: ${sale_price} ;;
    
filters: {
  field: is_returned
  value: "yes"
  } 
  }
  
  measure: total_gross_margin { 
    type: sum
    value_format_name: usd
    sql: ${gross_margin} ;;
    drill_fields: [
      detail*,
    ] 
  }
  
  measure: total_gross_margin_percentage { 
    type: number
    value_format_name: percent_2
    sql: 1.0 * ${total_gross_margin}/ NULLIF(${total_sale_price},0) ;; 
  }
  
  measure: total_sale_price { 
    type: sum
    value_format_name: usd
    sql: ${sale_price} ;;
    drill_fields: [
      detail*,
    ] 
  }
  
  measure: values { 
    type: number
    hidden: yes
    sql: ${cohort_values_0} + ${cohort_values_1} ;; 
  } 
  
set: detail {
  fields: [
      id, order_id, status, created_date, sale_price, products.brand, products.item_name, users.portrait, users.name, users.email,
    ]
  }
set: return_detail {
  fields: [
      id, order_id, status, created_date, returned_date, sale_price, products.brand, products.item_name, users.portrait, users.name, users.email,
    ]
  }
}
