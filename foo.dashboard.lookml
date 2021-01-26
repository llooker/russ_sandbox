- dashboard: foo
  title: Foo
  layout: newspaper
  tile_size: 100


  filters:

  elements:
  - col: 4
    column_limit: 50
    explore: order_items
    fields:
    - order_items.average_sale_price
    filters: {}
    font_size: medium
    height: 3
    limit: 500
    listen:
      Brand Name: products.brand
      Date: order_items.created_date
      State: users.state
    model: thelook
    name: Average Order Value
    note_display: below
    note_state: collapsed
    note_text: ''
    query_timezone: America/Los_Angeles
    row: 2
