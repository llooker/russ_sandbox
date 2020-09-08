include: "/simple/*.view.lkml"
include: "*.view.lkml"
# connec tion: "thelook_events_redshift"
connection: "bfw_bq"

    access_grant: abc { allowed_values: [
    "a",
    "b",
    "c",
    ]
  user_attribute: org_id }

    datagroup: mydatagroup { sql_trigger: select current_date ;;
  label: "Daily"
  description: "Should fire daily just afte midnight UTC" }
    datagroup: mydatagroup2 { sql_trigger: select convert_tz(current_date, 'America/Los_Angeles') ;;
  label: "Daily"
  description: "Should fire daily just afte midnight pacific" }

 explore: test1 {

  join: test2 {
    required_access_grants: [ abc,]
    relationship: many_to_one
    sql_on: ${test1.foo}=${test2.id} ;;
    type: left_outer }
  join: test3 {   relationship: many_to_one
    sql_on: ${test1.foo} = ${test3.id} ;; } }
