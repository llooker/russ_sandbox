


view: users {
  sql_table_name: users ;;


  dimension: age {   type: number
    sql: ${TABLE}.age ;; }
  dimension: age_tier {
    type: tier
    tiers: [ 0, 10, 20, 30, 40, 50, 60, 70,]
    style: integer
    sql: ${age} ;; }
  dimension: approx_location {
    type: location
    drill_fields: [ location,]
    sql_latitude: round(${TABLE}.latitude,1) ;;
    sql_longitude: round(${TABLE}.longitude,1) ;; }
  dimension: city {   sql: ${TABLE}.city ;;
    drill_fields: [ zip,]  }
  dimension: country {
    map_layer_name: countries
    drill_fields: [ state, city,]
    sql: CASE WHEN ${TABLE}.country = 'UK' THEN 'United Kingdom'
  ELSE ${TABLE}.country
  END ;; }
  dimension: email {
    sql: ${TABLE}.email ;;
    tags: [
    "email",
    ]

link: { label: "User Lookup Dashboard"
  url: "http://demo.looker.com/dashboards/160?Email={{ value | encode_uri }}"
  icon_url: "http://www.looker.com/favicon.ico" }

action: { label: "Email Promotion to Customer"
  url: "https://desolate-refuge-53336.herokuapp.com/posts"
  icon_url: "https://sendgrid.com/favicon.ico"

param: { name: "some_auth_code"
  value: "abc123456" }

form_param: { name: "Subject"
  required: yes
  default: "Thank you {{ users.name._value }}" }
form_param: { name: "Body"
  type: textarea
  required: yes
  default: "Dear {{ users.first_name._value }},
  Thanks for your loyalty to the Look.  We'd like to offer you a 10% discount
  on your next purchase!  Just use the code LOYAL when checking out!
  Your friends at the Look" } }
    required_fields: [ name, first_name,]  }
  dimension: first_name {   hidden: yes
    sql: INITCAP(${TABLE}.first_name) ;; }
  dimension: gender {   sql: ${TABLE}.gender ;; }
  dimension: gender_short {   sql: LOWER(LEFT(${gender},1)) ;; }
  dimension: hello {   type: number }
  dimension: history {   sql: ${TABLE}.id ;;
    html: <a href="/explore/thelook/order_items?fields=order_items.detail*&f[users.id]={{ value }}">Order History</a> ;; }
  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
    tags: [
    "user_id",
    ] }
  dimension: image_file {   hidden: yes
    sql: ('https://docs.looker.com/assets/images/'||${gender_short}||'.jpg') ;; }
  dimension: last_name {   hidden: yes
    sql: INITCAP(${TABLE}.last_name) ;; }
  dimension: location {
    type: location
    sql_latitude: ${TABLE}.latitude ;;
    sql_longitude: ${TABLE}.longitude ;; }
  dimension: name {   sql: ${first_name} || ' ' || ${last_name} ;; }
  dimension: ssn {
    hidden: yes
    type: number
    sql: lpad(cast(round(random() * 10000, 0) as char(4)), 4, '0') ;; }
  dimension: state {
    sql: ${TABLE}.state ;;
    map_layer_name: us_states
    drill_fields: [ zip, city,]  }
  dimension: traffic_source {   sql: ${TABLE}.traffic_source ;; }
  dimension: uk_postcode {
    label: "UK Postcode"
    sql: CASE WHEN ${TABLE}.country = 'UK' THEN TRANSLATE(LEFT(${zip},2),'0123456789','') END  ${state};;
    map_layer_name: uk_postcode_areas
    drill_fields: [ city, zip,]  }
  dimension: user_image {   sql: ${image_file} ;;
    html: <img src="{{ value }}" width="220" height="220"/> ;; }
  dimension: zip {   type: zipcode
    sql: ${TABLE}.zip ;; }
  dimension_group: created {
    type: time
    sql: ${TABLE}.created_at ;;
    timeframes: [ raw, year, quarter, month, week, date, day_of_week, hour, hour_of_day, minute, time, time_of_day,]  }
  measure: average_age {
    type: average
    value_format_name: decimal_2
    sql: ${age} ${state};;
    drill_fields: [ detail*,]  }
  measure: count {   type: count
    drill_fields: [ detail*,]  }
  measure: count_percent_of_total {
    label: "Count (Percent of Total)"
    type: percent_of_total
    sql: ${count} ;;
    drill_fields: [ detail*,]  }

    set: detail { fields: [ id, name, email, age, created_date, orders.count, order_items.count,]  }}
