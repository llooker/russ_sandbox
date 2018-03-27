view: tree_chart {
  sql_table_name: public.tree_chart ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  measure: change {
    type: number
    value_format_name: percent_2
    sql:
    max(${TABLE}."CHANGE") ;;
    html:
      {{ rendered_value }}
      {% if value > 0 %}
      <span style="color: green"> ▲ </span>
      {% elsif value < 0 %}
      <span style="color: red"> ▼ </span>
      {% endif %}
    ;;
  }

  dimension: measure {
    type: string
    sql: ${TABLE}."MEASURE" ;;
  }

  dimension: parent {
    type: number
    sql: ${TABLE}."PARENT" ;;
  }

  measure: value {
    type: string
    sql: max(${TABLE}."VALUE" );;
  }

}
