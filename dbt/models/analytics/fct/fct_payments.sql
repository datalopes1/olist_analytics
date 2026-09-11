with payments as (
    select * from {{ ref ('stg_order_payments') }}
),

customers as (
    select 
        o.order_id,
        d.customer_sk 
    from {{ ref('stg_orders') }} o 
    left join {{ ref('stg_customers') }} c on o.customer_id = c.customer_id 
    left join {{ ref('dim_customers') }} d on c.customer_unique_id = d.customer_unique_id
),

final as (
select 
    {{ dbt_utils.generate_surrogate_key(['p.order_id', 'p.payment_sequential']) }} as payment_sk,
    c.customer_sk,
    p.order_id,
    p.payment_type,
    p.payment_sequential,
    p.payment_installments,
    p.payment_value
from payments p
left join customers c on p.order_id = c.order_id
)

select * from final
