view: ranked_stack {
  derived_table: {
    sql:
      SELECT
            CASE
              WHEN {% parameter products.stack_by %} = 'Brand' THEN products.brand
              WHEN {% parameter products.stack_by %} = 'Category' THEN products.category
              WHEN {% parameter products.stack_by %} = 'Department' THEN products.department
              ELSE 'N/A'
            END
           AS "products.stack_dim"
        ,COALESCE(SUM((order_items.sale_price - inventory_items.cost) ), 0) AS "total_gross_margin"
        ,RANK() OVER (ORDER BY COALESCE(SUM((order_items.sale_price - inventory_items.cost) ), 0) DESC) AS RNK
      FROM order_items  AS order_items
      FULL OUTER JOIN inventory_items  AS inventory_items ON inventory_items.id = order_items.inventory_item_id
      LEFT JOIN products  AS products ON products.id = inventory_items.product_id
      WHERE
        1=1
        AND {% condition order_items.created_date %} order_items.created_at {% endcondition %}
      GROUP BY 1
      ORDER BY 2 DESC
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  filter: tail_threshold {
    type: number

  }

  dimension: products_stack_dim {
    hidden:  yes
    type: string
    sql: ${TABLE}."products.stack_dim" ;;
  }


  dimension: stacked_rank {
    type: string
    sql:
            CASE WHEN ${rnk} <= 10 then '0' || ${rnk} || ') '|| ${products_stack_dim}
            ELSE ${rnk} || ')' || ${products_stack_dim}
            end


    ;;
  }

  dimension: ranked_brand_with_tail {
    type: string
    sql:
          CASE WHEN {% condition tail_threshold %} ${rnk} {% endcondition %} THEN ${stacked_rank}
          ELSE 'x) Other'
          END

    ;;
  }


  dimension: total_gross_margin {
    type: number
    sql: ${TABLE}.total_gross_margin ;;
  }

  dimension: rnk {
    type: number
    sql: ${TABLE}.rnk ;;
  }

  set: detail {
    fields: [products_stack_dim, total_gross_margin, rnk]
  }
}
