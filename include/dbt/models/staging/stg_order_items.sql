with order_items as (
    select * from raw.order_items
),

final as (
select 
    order_id,
    order_item_id,
    product_id,
    seller_id,
    cast(shipping_limit_date as datetime) as shipping_limit_dt,
    cast(price as decimal(10, 2)) as price,
    cast(freight_value as decimal(10, 2)) as freight_value
from order_items
)

select * from final