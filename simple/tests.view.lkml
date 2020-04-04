


view: test1 {
   
   
   
  
  dimension: bar { 
    type: number
    sql: ${TABLE}.bar ;; 
  }
  
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
  
  dimension_group: created { 
    timeframes: [
      raw, year, quarter, month, week, date, day_of_week, hour, hour_of_day, minute, time, time_of_day,
    ]
    type: time
    sql: ${TABLE}.`id` ;; 
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
