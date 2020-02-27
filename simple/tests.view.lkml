
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
    
    ]
  sql: NVL([
    
    ],0) ;;
}


dimension: id {
  type: number
  sql: NVL(${TABLE}.`ID_`,0) ;;
  tags: [
    
    ]
}

}
