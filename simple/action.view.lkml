view: foo {
  sql_table_name: wow.wow ;;


  dimension: bar {
    sql: wow ;;
    required_access_grants: [foo]
  }


  }
