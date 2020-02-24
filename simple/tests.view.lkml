
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
  hidden: yes
}


dimension: cool {
  type: string
  hidden: yes
}


dimension: id {
  type: string
  sql: ${TABLE}.`ID_` ;;
  hidden: yes
}

}
view: test2_extended {

extends: [test2]
}

view: test2_extended {


}
