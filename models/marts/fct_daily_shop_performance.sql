{{ config(materialized='view') }}

with orders as (
    select * from {{ ref('fct_orders') }}
),

order_items as (
    select * from {{ ref('fct_order_items') }}
),

joined as (
    select
        orders.ordered_date,
        orders.shop_id,
        orders.channel,
        orders.order_id,
        orders.net_revenue_gold,
        order_items.quantity,
        order_items.line_revenue_gold
    from orders
    left join order_items
        on orders.order_id = order_items.order_id
    where orders.order_status != 'cancelled'
),

final as (
    select
        ordered_date,
        shop_id,
        channel,
        count(order_id) as order_count,
        sum(quantity) as units_sold,
        sum(net_revenue_gold) as net_revenue_gold,
        sum(line_revenue_gold) as line_revenue_gold
    from joined
    group by 1, 2, 3
)

select * from final
