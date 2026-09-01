with order_items as (
    select * from {{ ref('stg__order_items') }}
),

orders as (
    select * from {{ ref('stg__orders') }}
),

final as (
    select
        order_items.order_id,
        order_items.seller_id,
        orders.customer_id,
        order_items.product_id,
        order_items.order_item,
        order_items.price,
        order_items.freight_value
    from order_items
    left join orders on order_items.order_id = orders.order_id
)

select * from final
