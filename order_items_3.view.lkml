



view: order_items_3 {

  sql_table_name: PUBLIC.ORDER_ITEMS ;; 
   
   
  
  dimension: id { 
    type: number
    sql: ${TABLE}.ID ;; 
  }
  
  dimension: inventory_item_id { 
    type: number
    sql: ${TABLE}.INVENTORY_ITEM_ID ;; 
  }
  
  dimension: order_id { 
    type: number
    sql: ${TABLE}.ORDER_ID ;; 
  }
  
  dimension: sale_price { 
    type: number
    sql: ${TABLE}.SALE_PRICE ;; 
  }
  
  dimension: status { 
    type: string
    sql: ${TABLE}.STATUS ;; 
  }
  
  dimension: user_id { 
    type: number
    sql: ${TABLE}.USER_ID ;; 
  } 
  
  dimension_group: created_at { 
    timeframes: [
      raw, year, quarter, month, week, date, day_of_week, hour, hour_of_day, minute, time, time_of_day,
    ]
    type: time
    sql: ${TABLE}.CREATED_AT ;; 
  }
  
  dimension_group: delivered_at { 
    timeframes: [
      raw, year, quarter, month, week, date, day_of_week, hour, hour_of_day, minute, time, time_of_day,
    ]
    type: time
    sql: ${TABLE}.DELIVERED_AT ;; 
  }
  
  dimension_group: returned_at { 
    timeframes: [
      raw, year, quarter, month, week, date, day_of_week, hour, hour_of_day, minute, time, time_of_day,
    ]
    type: time
    sql: ${TABLE}.RETURNED_AT ;; 
  }
  
  dimension_group: shipped_at { 
    timeframes: [
      raw, year, quarter, month, week, date, day_of_week, hour, hour_of_day, minute, time, time_of_day,
    ]
    type: time
    sql: ${TABLE}.SHIPPED_AT ;; 
  } 
  
  measure: count { 
    type: count 
  }
  
  measure: total_id { 
    type: sum
    sql: ${id} ;; 
  }
  
  measure: total_inventory_item_id { 
    type: sum
    sql: ${inventory_item_id} ;; 
  }
  
  measure: total_order_id { 
    type: sum
    sql: ${order_id} ;; 
  }
  
  measure: total_sale_price { 
    type: sum
    sql: ${sale_price} ;; 
  }
  
  measure: total_user_id { 
    type: sum
    sql: ${user_id} ;; 
  } 
  
}
