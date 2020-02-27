
view: test1 {


dimension: foo {
  sql: ${TABLE}.id ;;
  tags: [
    "Generated Code",
    "wut",
    "cool",
    "crazy_right?",
    ]
  suggestions: [
    "hello",
    "sneak attack",
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
