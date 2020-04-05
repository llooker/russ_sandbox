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


explore: usr {
  join: usr_profile {
    type: left_outer
    relationship: one_to_one
    sql: ${usr.id} =  ${usr_profile.user_id};;
  }
}
