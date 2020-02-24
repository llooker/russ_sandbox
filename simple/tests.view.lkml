
view: test1 {


dimension: foo {
  sql: ${TABLE}.id ;;
  tags: [
    "Generated Code",
    ]
}

}

view: test2 {


dimension: bar {
  
}


dimension: id {
  type: string
  sql: ${TABLE}.`ID_` ;;
}

}
