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
      <span style="color: rgba(0,0,0,0)">.</span><br>
      <span style="color: rgba(0,0,0,0)">.</span><br>
      {% if value > 0 %}
      <span style="color: #50AE55; font-weight: bold">{{ rendered_value }} ▲</span>
      {% elsif value < 0 %}
      <span style="color: #D0021B; font-weight: bold">{{ rendered_value }} ▼</span>
      {% endif %}
      <br><span style="color: rgba(0,0,0,0);">-------------------------</span>
    ;;
  }

  dimension: measure {
    type: string
    sql: ${TABLE}."MEASURE" ;;
    html:
     <span id="{{ id._value }}" style="width: 50px"> {{ rendered_value }}</span>
    ;;

  }

  dimension: parent {
    type: number
    sql: ${TABLE}."PARENT" ;;
  }

  measure: value {
    type: string
    sql: max(${TABLE}."VALUE" );;
    html:
    <br><span style="color: #E7E8E8">-------------------------</span><br>
    <span style="text-align: right;">{{rendered_value}} <span style="color: rgba(0,0,0,0);">▲</span></span><br><span style="color: #E7E8E8">-------------------------</span>
    ;;
  }

}
