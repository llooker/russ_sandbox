

view: test1 {


#Auto Generated Code... comments in this will file may disappear on automation run
dimension: foo {
  sql: NVL(${TABLE}.foo,0) ;;
  tags: [
    "Generated Code",
    "Detected Generated Code",
    ]
  suggestions: [
    "suggestion1",
    ]
}


dimension: my_number {
  type: number
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
  type: number
  sql: ${TABLE}._id_ ;;
}

}
