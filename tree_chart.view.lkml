view: tree_chart {
  sql_table_name: public.tree_chart ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  measure: change {
    type: number
    sql: max(${TABLE}."CHANGE") ;;
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

  measure: count {
    type: count
    drill_fields: [id]
  }
}
