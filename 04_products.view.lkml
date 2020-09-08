view: products {
  sql_table_name: products ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  filter: stack_by {
    type: string
    suggestions: ["Brand","Category","Department"]
  }

  dimension: stack_dim {
    type: string
    sql:
      CASE
        WHEN {% parameter stack_by %} = 'Brand' THEN ${brand}
        WHEN {% parameter stack_by %} = 'Category' THEN ${category}
        WHEN {% parameter stack_by %} = 'Department' THEN ${department}
        ELSE 'N/A'
      END
    ;;
#     link: {
#       url: "/dashboards/1835?stack%20by={{ _fil ters['products.stack_by'] | url_encode }}
#       &{{ _fil ters['products.stack_by'] }}={{ value | url_encode }}
#       &Department={{ _fi lters['products.department'] }}
#       &Brand={{ _fil ters['products.brand'] }}
#       &Category={{ _fil ters['products.category'] }}
#       "
#       label: "See Stacked by {{ _filters['products.stack_by'] }}, for just {{value}}"
#     }
#       link: {
#         url: "/dashboards/1835?{{ _filters['products.stack_by'] }}={{ value | url_encode }}&stack%20by=Brand
#         &Department={{ _filters['products.department'] }}
#         &Brand={{ _filters['products.brand'] }}
#         &Category={{ _filters['products.category'] }}
#         "
#         label: "See Stacked by Brand, for just {{value}}"
#       }
#       link: {
#         url: "/dashboards/1835?{{ _filters['products.stack_by'] }}={{ value | url_encode }}&stack%20by=Category
#         &Department={{ _filters['products.department'] }}
#         &Brand={{ _filters['products.brand'] }}
#         &Category={{ _filters['products.category'] }}
#         "
#         label: "See Stacked by Category, for just {{value}}"
#       }
#       link: {
#         url: "/dashboards/1835?Category={{ _filters['products.category'] }}&stack%20by=Department
#         &{{ _filters['products.stack_by'] }}={{ value |  url_encode }}
#         &Department={{ _filters['products.department'] }}
#         &Brand={{ _filters['products.brand'] }}
#
#         "
#         label: "See Stacked by Department, for just {{value}}"
#       }
    }




  dimension: category {
    sql: TRIM(${TABLE}.category) ;;
    drill_fields: [item_name]
  }

  dimension: item_name {
    sql: TRIM(${TABLE}.name) ;;
  }

  dimension: brand {
    sql: TRIM(${TABLE}.brand) ;;

    link: {
      label: "Website"
      url: "http://www.google.com/search?q={{ value | encode_uri }}+clothes&btnI"
      icon_url: "http://www.google.com/s2/favicons?domain=www.{{ value | encode_uri }}.com"
    }

    link: {
      label: "Facebook"
      url: "http://www.google.com/search?q=site:facebook.com+{{ value | encode_uri }}+clothes&btnI"
      icon_url: "https://static.xx.fbcdn.net/rsrc.php/yl/r/H3nktOa7ZMg.ico"
    }

    link: {
      label: "{{value}} Analytics Dashboard"
      url: "/dashboards/8?Brand%20Name={{ value | encode_uri }}"
      icon_url: "http://www.looker.com/favicon.ico"
    }

    drill_fields: [category, item_name]
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: department {
    sql: TRIM(${TABLE}.department) ;;
  }

  dimension: sku {
    sql: ${TABLE}.sku ;;
  }

  dimension: distribution_center_id {
    type: number
    sql: ${TABLE}.distribution_center_id ;;
  }

  ## MEASURES ##

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: brand_count {
    type: count_distinct
    sql: ${brand} ;;
    drill_fields: [brand, detail2*, -brand_count] # show the brand, a bunch of counts (see the set below), don't show the brand count, because it will always be 1
  }

  measure: category_count {
    alias: [category.count]
    type: count_distinct
    sql: ${category} ;;
    drill_fields: [category, detail2*, -category_count] # don't show because it will always be 1
  }

  measure: department_count {
    alias: [department.count]
    type: count_distinct
    sql: ${department} ;;
    drill_fields: [department, detail2*, -department_count] # don't show because it will always be 1
  }

  set: detail {
    fields: [id, item_name, brand, category, department, retail_price, customers.count, orders.count, order_items.count, inventory_items.count]
  }

  set: detail2 {
    fields: [category_count, brand_count, department_count, count, customers.count, orders.count, order_items.count, inventory_items.count, products.count]
  }
}
