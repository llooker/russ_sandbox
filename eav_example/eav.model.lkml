connection: "snowlooker"

    access_grant: org_8 {
  user_attribute: org_id
  allowed_values: [
    "8",
    ]
  }
    access_grant: org_101 {
  user_attribute: org_id
  allowed_values: [
    "101",
    ]
  }
    access_grant: org_102 {
  user_attribute: org_id
  allowed_values: [
    "102",
    ]
  }


explore: usr {

  

  
  join: usr_profile { 
    type: left_outer
    relationship: one_to_one
    sql_on: ${usr.id} =  ${usr_profile.user_id} ;; }
}



explore: _eav_flattener {

  from: eav_source
  hidden: yes

  
}


view: usr {

  sql_table_name: public.users ;;
  dimension: email { 
   }
  
  dimension: id { 
   }
  
  dimension_group: created { 
    timeframes: [
      raw, year, quarter, month, week, date, day_of_week, hour, hour_of_day, minute, time, time_of_day,
    ]
    type: time
    sql: ${TABLE}.`` ;; }
  
  
}


view: usr_profile {

  derived_table: {
  explore_source: _eav_flattener {
  
    column: user_id {
      field: _eav_flattener.user_id
  }
    column: org_id {
      field: _eav_flattener.org_id
  }
    column: c_donation_amount {
      field: _eav_flattener.c_donation_amount
  }
    column: c_highest_achievement {
      field: _eav_flattener.c_highest_achievement
  }
    column: c_highest_achievement {
      field: _eav_flattener.c_highest_achievement
  }
    column: c_monthly_contribution {
      field: _eav_flattener.c_monthly_contribution
  }
    column: c_highest_achievement {
      field: _eav_flattener.c_highest_achievement
  }
    column: c_monthly_contribution {
      field: _eav_flattener.c_monthly_contribution
  }
    column: c_monthly_contribution {
      field: _eav_flattener.c_monthly_contribution
  }
    column: age {
      field: _eav_flattener.age
  }
    column: c_monthly_contribution {
      field: _eav_flattener.c_monthly_contribution
  }
  }
  }
  dimension: age { 
    type: number
    sql: ${TABLE}.age ;;
    required_access_grants: [
      org_101,
    ] }
  
  dimension: c_donation_amount { 
    type: number
    sql: ${TABLE}.c_donation_amount ;;
    required_access_grants: [
      org_8,
    ] }
  
  dimension: c_highest_achievement { 
    type: string
    sql: ${TABLE}.c_highest_achievement ;;
    required_access_grants: [
      org_101,
    ] }
  
  dimension: c_monthly_contribution { 
    type: number
    sql: ${TABLE}.c_monthly_contribution ;;
    required_access_grants: [
      org_102,
    ] }
  
  dimension: org_id { 
   }
  
  dimension: user_id { 
   }
  
  
  measure: age_total { 
    type: sum
    sql: ${age} ;;
    required_access_grants: [
      org_101,
    ] }
  
  measure: c_donation_amount_total { 
    type: sum
    sql: ${c_donation_amount} ;;
    required_access_grants: [
      org_8,
    ] }
  
  measure: c_monthly_contribution_total { 
    type: sum
    sql: ${c_monthly_contribution} ;;
    required_access_grants: [
      org_102,
    ] }
  
}


view: eav_source {

  sql_table_name: (
  SELECT 1 as user_id, 8 as org_id, 'c_donation_amount' as field_name, '40' as value, 'int' as datatype UNION ALL
  SELECT 1, 8, 'c_highest_achievement', 'gold badge', 'varchar' UNION ALL
  SELECT 2, 101, 'c_highest_achievement', 'silver badge', 'varchar' UNION ALL
  SELECT 2, 101, 'c_monthly_contribution', '300', 'int' UNION ALL
  SELECT 3, 101, 'c_highest_achievement', 'bronze badge', 'varchar' UNION ALL
  SELECT 3, 101, 'c_monthly_contribution', '350', 'int'
  SELECT 4, 101, 'c_monthly_contribution', '350', 'int'
  SELECT 4, 101, 'age', '32', 'int'
  SELECT 5, 102, 'c_monthly_contribution', '100', 'int'
  ) ;;
  dimension: datatype { 
    type: string }
  
  dimension: field_name { 
    type: string }
  
  dimension: org_id { 
    type: number }
  
  dimension: user_id { 
    type: number }
  
  dimension: value { 
    type: string }
  
  
  measure: age { 
    type: max
    sql: CASE WHEN ${field_name} = 'age' THEN ${value} ELSE NULL END ;; }
  
  measure: c_donation_amount { 
    type: max
    sql: CASE WHEN ${field_name} = 'c_donation_amount' THEN ${value} ELSE NULL END ;; }
  
  measure: c_highest_achievement { 
    type: max
    sql: CASE WHEN ${field_name} = 'c_highest_achievement' THEN ${value} ELSE NULL END ;; }
  
  measure: c_monthly_contribution { 
    type: max
    sql: CASE WHEN ${field_name} = 'c_monthly_contribution' THEN ${value} ELSE NULL END ;; }
  
}
