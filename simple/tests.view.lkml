
view: test1 {


dimension: foo {
  sql: ${TABLE}.id ;;
  tags: [
    "Generated Code",
    "wut",
    "cool",
    ]
  suggestions: [
    "hello",
    ]
}

}

view: test2 {


dimension: bar {
  hidden: yes
}


dimension: cool {
  type: string
  hidden: yes
}


dimension: id {
  type: number
  sql: ${TABLE}.`ID_` ;;
  hidden: yes
}

}
