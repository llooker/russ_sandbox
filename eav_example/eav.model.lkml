connection: "snowlooker"

view: usr {
  sql_table_name: public.users ;;
  dimension: id {}
  dimension_group: created {}
  dimension: email {}
}

view: usr_profile {
  dimension: user_id {}
  dimension: cust_id {}
}

view: custom_profile_fields_raw {
  sql_table_name:
  (
      SELECT 1 as user_id, 8 as cust_id, 'c_donation_amount' as field_name, '40' as value, 'int' as datatype UNION ALL
      SELECT 1, 8, 'c_highest_achievement', 'gold badge', 'varchar' UNION ALL
      SELECT 2, 101, 'c_highest_achievement', 'silver badge', 'varchar' UNION ALL
      SELECT 2, 101, 'c_monthly_contribution', '300', 'int' UNION ALL
      SELECT 3, 101, 'c_highest_achievement', 'bronze badge', 'varchar' UNION ALL
      SELECT 3, 101, 'c_monthly_contribution', '350', 'int'
  )

  ;;
  dimension: user_id { type: number }
  dimension: cust_id { type: number }
  dimension: field_name { type: string }
  dimension: value { type: string }
  dimension: datatype { type: string }
}

explore: usr {
  join: usr_profile {
    type: left_outer
    relationship: one_to_one
    sql: ${usr.id} =  ${usr_profile.user_id};;
  }
}
