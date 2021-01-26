connection: "bfw_bq"

# include: "/views/*.view.lkml"                # include all views in the views/ folder in this project
# include: "/**/view.lkml"                   # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
# explore: order_items {
#   join: orders {
#     relationship: many_to_one
#     sql_on: ${orders.id} = ${order_items.order_id} ;;
#   }
#
#   join: users {
#     relationship: many_to_one
#     sql_on: ${users.id} = ${orders.user_id} ;;
#   }
# }

view: cool {
  sql_table_name:
      (
        select 1 as foo, 1 as bar, 1 as baz UNION ALL
        select 2 as foo, null as bar, 1 as baz UNION ALL
        select 3 as foo, 1 as bar, null as baz UNION ALL
        select 4 as foo, null as bar, null as baz

        )
  ;;
  dimension: foo {
    case: {
      when: {
        label: "Bar is here"
        sql: ${bar} is not null AND ${baz} is NULL ;;
      }
      when: {
        label: "Baz is here"
        sql: ${baz} is not null AND ${bar} is NULL ;;
      }
      when: {
        label: "Both Bar and Baz are here"
        sql: ${baz} is not null AND ${bar} is not NULL ;;
      }
      else: "Neither Baz nor Bar are here"
    }
#     case: {
#       when: {
#       label: "Baz is here"
#       sql: ${baz} is not null ;;
#       }
    }

  dimension: bar {}
  dimension: baz {}
}

explore: cool {

}
