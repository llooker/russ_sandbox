
view: test1 {


dimension: foo {
  sql: NVL(${TABLE}.scoop,0) ;;
  tags: [
    "Generated Code",
    "wut",
    "cool",
    "crazy_right?",
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
  tags: []
}

}
