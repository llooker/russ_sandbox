

view: test1 {


dimension: bar {
  type: number
  sql: ${TABLE}.bar ;;
}


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
  type: string
}


dimension: my_number {
  type: number
}


dimension: my_number_2 {
  type: number
}


measure: total_bar {
  type: sum
  sql: ${bar} ;;
}


measure: total_my_number {
  type: sum
  sql: ${my_number} ;;
}


measure: total_my_number_2 {
  type: sum
  sql: ${my_number_2} ;;
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
