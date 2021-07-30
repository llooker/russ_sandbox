# connection: "thelook_events_redshift"
connection: "bfw_bq"
persist_for: "1 hour"  # cache all query results for one hour
label: "1) eCommerce with Event Data"


include: "*.view" # include all the views
# include: "*.dashboard" # include all the dashboards



######## intel comma bug 12/13/2018 ######

explore: repro {
  always_filter: {
    filters: {
      field: repo.drink
      value: "-NULL"
      }
    }
  }

view: repro {
  derived_table: {
    sql:
      SELECT 'arnold,palmer' as drink, 10 as price UNION ALL
      SELECT 'iced,tea', 9 UNION ALL
      SELECT 'coke,classic', 5 UNION ALL
      SELECT 'milk', 2 UNION ALL
      SELECT 'water', 0

    ;;
  }

  dimension: drink {
    type: string
    sql: ${TABLE}.drink ;;
    link: {
      label: "repro"
      url: "/dashboards/111?drink%20name={{ _filters['repro.drink'] | url_encode }}&drink%20name=\"{{ value | url_encode }}\""
      icon_url: "https://looker.com/favicon.ico"
    }
  }

  measure: price {
    type: sum
    sql: ${TABLE}.price ;;
  }


}



#####




############ Base Explores #############

# If necessary, uncomment the line below to include explore_source.
# include: "russ_sandbox.model.lkml"

view: ndt {
  derived_table: {
    explore_source: order_items {
      column: new_dimension {}
      column: total_sale_price {}
      derived_column: rank {
        sql: ROW_NUMBER() OVER (ORDER BY total_sale_price DESC) ;;
      }
      bind_filters: {
        from_field: order_items.stack_by
        to_field: order_items.stack_by
      }
    }
  }
  dimension: new_dimension {
    html:

    {% if order_items.stack_by._parameter_value == 'Brand' %} {{ products.brand._value }}
    {% elsif order_items.stack_by._parameter_value == 'Category' %}  {{ products.category._value }}
    {% elsif order_items.stack_by._parameter_value == 'Department' %} {{ products.department._value }}
    {% elsif order_items.stack_by._parameter_value == 'State' %} {{ users.state._value }}
    {% else %} 'N/A'
    {% endif %}

    ;;
  }
  dimension: total_sale_price {
    value_format: "$#,##0.00"
    type: number
  }
}




explore: order_items {
  label: "(1) Orders, Items and Users"
  view_name: order_items

#   access_filter: {
#     field: products.brand
#     user_attribute: brand
#   }

  join: order_facts {
    view_label: "Orders"
    relationship: many_to_one
    sql_on: ${order_facts.order_id} = ${order_items.order_id} ;;
  }

  join: inventory_items {
    #Left Join only brings in items that have been sold as order_item
    type: left_outer
    relationship: one_to_one
    sql_on: ${inventory_items.id} = ${order_items.inventory_item_id} ;;
  }

  join: users {
    relationship: many_to_one
    sql_on: ${order_items.user_id} = ${users.id} ;;
  }

  join: user_order_facts {
    view_label: "Users"
    relationship: many_to_one
    sql_on: ${user_order_facts.user_id} = ${order_items.user_id} ;;
  }

  join: products {
    relationship: many_to_one
    sql_on: ${products.id} = ${inventory_items.product_id} ;;
  }

  join: repeat_purchase_facts {
    relationship: many_to_one
    type: full_outer
    sql_on: ${order_items.order_id} = ${repeat_purchase_facts.order_id} ;;
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${distribution_centers.id} = ${inventory_items.product_distribution_center_id} ;;
    relationship: many_to_one
  }

  join: ndt {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.new_dimension}  = ${ndt.new_dimension};;
  }

  join: ranked_stack {
    type: left_outer
    sql_on:

       CASE
         WHEN {% parameter products.stack_by %} = 'Brand' THEN ${products.brand}
         WHEN {% parameter products.stack_by %} = 'Category' THEN ${products.category}
         WHEN {% parameter products.stack_by %} = 'Department' THEN ${products.department}
         WHEN {% parameter products.stack_by %} = 'State' THEN ${users.state}
         ELSE 'N/A'
       END = ${ranked_stack.products_stack_dim}  ;;
    relationship: many_to_one
  }
}



#########  Event Data Explores #########

explore: events {
  label: "(2) Web Event Data"

  join: sessions {
    sql_on: ${events.session_id} =  ${sessions.session_id} ;;
    relationship: many_to_one
  }

  join: session_landing_page {
    from: events
    sql_on: ${sessions.landing_event_id} = ${session_landing_page.event_id} ;;
    fields: [simple_page_info*]
    relationship: one_to_one
  }

  join: session_bounce_page {
    from: events
    sql_on: ${sessions.bounce_event_id} = ${session_bounce_page.event_id} ;;
    fields: [simple_page_info*]
    relationship: many_to_one
  }

  join: product_viewed {
    from: products
    sql_on: ${events.viewed_product_id} = ${product_viewed.id} ;;
    relationship: many_to_one
  }

  join: users {
    sql_on: ${sessions.session_user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: user_order_facts {
    sql_on: ${users.id} = ${user_order_facts.user_id} ;;
    relationship: one_to_one
    view_label: "Users"
  }
}

explore: sessions {
  label: "(3) Web Session Data"

  join: events {
    sql_on: ${sessions.session_id} = ${events.session_id} ;;
    relationship: one_to_many
  }

  join: product_viewed {
    from: products
    sql_on: ${events.viewed_product_id} = ${product_viewed.id} ;;
    relationship: many_to_one
  }

  join: session_landing_page {
    from: events
    sql_on: ${sessions.landing_event_id} = ${session_landing_page.event_id} ;;
    fields: [session_landing_page.simple_page_info*]
    relationship: one_to_one
  }

  join: session_bounce_page {
    from: events
    sql_on: ${sessions.bounce_event_id} = ${session_bounce_page.event_id} ;;
    fields: [session_bounce_page.simple_page_info*]
    relationship: one_to_one
  }

  join: users {
    relationship: many_to_one
    sql_on: ${users.id} = ${sessions.session_user_id} ;;
  }

  join: user_order_facts {
    relationship: many_to_one
    sql_on: ${user_order_facts.user_id} = ${users.id} ;;
    view_label: "Users"
  }
}


#########  Advanced Extensions #########

explore: affinity {
  label: "(4) Affinity Analysis"

  always_filter: {
    filters: {
      field: affinity.product_b_id
      value: "-NULL"
    }
  }

  join: product_a {
    from: products
    view_label: "Product A Details"
    relationship: many_to_one
    sql_on: ${affinity.product_a_id} = ${product_a.id} ;;
  }

  join: product_b {
    from: products
    view_label: "Product B Details"
    relationship: many_to_one
    sql_on: ${affinity.product_b_id} = ${product_b.id} ;;
  }
}

explore: orders_with_share_of_wallet_application {
  label: "(5) Share of Wallet Analysis"
  extends: [order_items]
  view_name: order_items

  join: order_items_share_of_wallet {
    view_label: "Share of Wallet"
  }
}

explore: journey_mapping {
  label: "(6) Customer Journey Mapping"
  extends: [order_items]
  view_name: order_items

  join: repeat_purchase_facts {
    relationship: many_to_one
    sql_on: ${repeat_purchase_facts.next_order_id} = ${order_items.order_id} ;;
    type: left_outer
  }

  join: next_order_items {
    from: order_items
    sql_on: ${repeat_purchase_facts.next_order_id} = ${next_order_items.order_id} ;;
    relationship: many_to_many
  }

  join: next_order_inventory_items {
    from: inventory_items
    relationship: many_to_one
    sql_on: ${next_order_items.inventory_item_id} = ${next_order_inventory_items.id} ;;
  }

  join: next_order_products {
    from: products
    relationship: many_to_one
    sql_on: ${next_order_inventory_items.product_id} = ${next_order_products.id} ;;
  }
}


explore: inventory_items{
  label: "(7) Stock Analysis"
  fields: [ALL_FIELDS*,-order_items.median_sale_price]

  join: order_facts {
    view_label: "Orders"
    relationship: many_to_one
    sql_on: ${order_facts.order_id} = ${order_items.order_id} ;;
  }

  join: order_items {
    #Left Join only brings in items that have been sold as order_item
    type: left_outer
    relationship: many_to_one
    sql_on: ${inventory_items.id} = ${order_items.inventory_item_id} ;;
  }

  join: users {
    relationship: many_to_one
    sql_on: ${order_items.user_id} = ${users.id} ;;
  }

  join: user_order_facts {
    view_label: "Users"
    relationship: many_to_one
    sql_on: ${user_order_facts.user_id} = ${order_items.user_id} ;;
  }

  join: products {
    relationship: many_to_one
    sql_on: ${products.id} = ${inventory_items.product_id} ;;
  }

  join: repeat_purchase_facts {
    relationship: many_to_one
    type: full_outer
    sql_on: ${order_items.order_id} = ${repeat_purchase_facts.order_id} ;;
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${distribution_centers.id} = ${inventory_items.product_distribution_center_id} ;;
    relationship: many_to_one
  }
}

explore: inventory_snapshot {
  label: "(8) Historical Stock Snapshot Analysis"
  join: trailing_sales_snapshot {
    sql_on: ${inventory_snapshot.product_id}=${trailing_sales_snapshot.product_id}
    AND ${inventory_snapshot.snapshot_date}=${trailing_sales_snapshot.snapshot_date};;
    type: left_outer
    relationship: one_to_one
  }

  join: products {
    sql_on: ${inventory_snapshot.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    sql_on: ${products.distribution_center_id}=${distribution_centers.id} ;;
    relationship: many_to_one
  }
}






















explore: kitten_order_items {
  label: "Order Items (Kittens)"
  hidden: yes
  extends: [order_items]

  join: users {
    view_label: "Kittens"
    from: kitten_users
  }
}
