

view: test1 {


#Auto Generated Code
dimension: foo {
  sql: NVL(${TABLE}.foo,0) ;;
  tags: [
    "Generated Code",
    "wut",
    "cool",
    "crazy_right?",
    "Detected Generated Code",
    ]
  suggestions: [
    "hello",
    "washington_post",
    ]
}

}

view: test2 {


dimension: bar {
  hidden: yes
}


dimension: id {
  type: number
  sql: NVL(${TABLE}.`ID_`,0) ;;
}

}

view: test3 {


dimension: id {
  type: string
  sql: ${TABLE}._id_ ;;
}

}
