
view: test1 {


dimension: foo {
  sql: ${TABLE}.scoop ;;
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
  tags: [
    "x",
    ]
}


dimension: id {
  type: number
  sql: ${TABLE}.`ID_` ;;
  tags: [
    "x",
    ]
}

}
