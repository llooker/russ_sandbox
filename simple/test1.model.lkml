include: "/simple/*.view.lkml"
include: "*.view.lkml"
connection: "thelook_events_redshift"

explore: test1 {
    
join: test2 {
    sql_on: ${test1.foo}=${test2.id} ;;
}

    
join: test3 {
    
}

}

