include: "/simple/*.view.lkml"
include: "*.view.lkml"
connection: "thelook_events_redshift"

explore: test1 {
    
join: test2 {
    relationship: many_to_one
  sql_on: ${test1.foo}=${test2.id} ;;
  type: left_outer
}

    
join: test3 {
    relationship: many_to_one
  sql_on: ${test1.foo} = ${test3.id} ;;
}

}

