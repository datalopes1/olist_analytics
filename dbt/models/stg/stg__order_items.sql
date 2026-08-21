with source as (
    select * from {{ source('db', 'order_items') }}
),

final as (
    select
        order_id,
        product_id,
        seller_id,
        order_item_id as order_item,
        price,
        freight_value
    from source
)

select * from final
