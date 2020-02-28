

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


}
view: test1_extended {

extends: [test1]
}

view: test1_extended {


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
