with payments as (
    select * from {{ ref ('stg_order_payments') }}
),

final as (
select 
    {{ dbt_utils.generate_surrogate_key(['order_id', 'payment_sequential']) }} as payment_sk,
    order_id,
    payment_type,
    payment_sequential,
    payment_installments,
    payment_value
from payments
)

select * from final
