with order_payments as (
    select * from raw.order_payments
)

select 
    order_id,
    payment_sequential,
    upper(replace(payment_type, '_', ' ')) as payment_type,
    payment_installments,
    cast(payment_value as decimal(10, 2)) as payment_value
from order_payments