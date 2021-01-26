  connection: "bfw_bq" 

view: usr {
  sql_table_name: public.users ;; 
  dimension: email {}
  dimension: id {} 
  dimension_group: created {  timeframes: [raw, date, month, year] } 
}
view: usr_profile {
  derived_table: {       
      explore_source: _eav_flattener {
        column: user_id { field: _eav_flattener.user_id }
        column: org_id { field: _eav_flattener.org_id } }
   } 
  dimension: org_id {}
  dimension: user_id {} 
}
view: eav_source {
  sql_table_name: (
      SELECT 1 as user_id, 8 as org_id, 'c_donation_amount' as field_name, '40' as value, 'int' as datatype UNION ALL
      SELECT 1, 8, 'c_highest_achievement', 'gold badge', 'varchar' UNION ALL
      SELECT 2, 101, 'c_highest_achievement', 'silver badge', 'varchar' UNION ALL
      SELECT 2, 101, 'c_monthly_contribution', '300', 'int' UNION ALL
      SELECT 3, 101, 'c_highest_achievement', 'bronze badge', 'varchar' UNION ALL
      SELECT 3, 101, 'c_monthly_contribution', '350', 'int' UNION ALL
      SELECT 4, 101, 'c_monthly_contribution', '350', 'int' UNION ALL
      SELECT 4, 101, 'age', '32', 'int' UNION ALL
      SELECT 5, 102, 'c_monthly_contribution', '100', 'int'
  ) ;; 
  dimension: datatype { type: string }
  dimension: field_name { type: string }
  dimension: org_id { type: number }
  dimension: user_id { type: number }
  dimension: value { type: string } 
}

explore: usr {
  join: usr_profile {
      type: left_outer
      relationship: one_to_one
      sql_on: ${usr.id} =  ${usr_profile.user_id} ;; 
  } 
  access_filter: {     
    field: usr_profile.org_id    
    user_attribute: org_id
   } 
}
explore: _eav_flattener {
  from: eav_source
  hidden: yes 
}