

view: test1 {


dimension: bar {
  type: number
  sql: ${TABLE}.bar ;;
}


filter: comparison_period {
  type: date
  sql: 
            ${created_raw}>= {% date_start comparison_period  %}
            AND ${created_raw} <= {% date_end reporting_period %}
         ;;
}


dimension_group: created {
  timeframes: [raw
  ,year
  ,quarter
  ,month
  ,week
  ,date
  ,day_of_week
  ,hour
  ,hour_of_day
  ,minute
  ,time
  ,time_of_day]
  type: time
  sql: ${TABLE}.`created` ;;
}


#Auto Generated Code... comments in this will file may disappear on automation run
dimension: foo {
  sql: NVL(${TABLE}.foo,0) ;;
  tags: [
    "Generated Code",
    "Detected Generated Code",
    ]
  suggestions: [
    "suggestion1",
    ]
  type: string
}


dimension: my_number {
  type: number
}


filter: reporting_period {
  type: date
}


measure: comparison_period_measure {
  type: count_distinct
  sql: 
          CASE 
           WHEN {% condition comparison_period %} ${created_raw} {% endcondition %} THEN ${foo}
           ELSE NULL
          END
         ;;
}


measure: reporting_period_measure {
  type: count_distinct
  sql: CASE 
                     WHEN {% condition reporting_period %} ${created_raw} {% endcondition %} THEN ${foo}
                     ELSE NULL
                    END
                     ;;
}


measure: total_bar {
  type: sum
  sql: ${bar} ;;
}


measure: total_my_number {
  type: sum
  sql: ${my_number} ;;
}

}

view: test2 {


dimension: bar {
  hidden: yes
}


dimension: id {
  type: number
  sql: NVL(${TABLE}.`ID_`,0) ;;
}

}

view: test3 {


dimension: id {
  type: number
  sql: ${TABLE}._id_ ;;
}

}
