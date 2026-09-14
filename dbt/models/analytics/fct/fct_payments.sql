with payments as (
    select * from {{ ref('stg_order_payments') }}
),

customers as (
    select * from {{ ref('stg_customers') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
),

payment as (
select 
    pa.order_id,
    cs.customer_unique_id,
    pa.payment_sequential,
    pa.payment_installments,
    pa.payment_type,
    date_trunc('day', od.approved_at) as approved_at,
    pa.payment_value
from payments pa
left join orders od on pa.order_id = od.order_id
left join customers cs on od.customer_id = cs.customer_id
),

final as (
select
    pa.order_id,
    {{ dbt_utils.generate_surrogate_key(['pa.order_id', 'pa.payment_sequential']) }} as payment_sk,
    dc.customer_sk,
    pa.payment_sequential,
    pa.payment_installments,
    pa.payment_type,
    pa.approved_at,
    pa.payment_value
from payment pa
left join {{ ref('dim_customers') }} dc on pa.customer_unique_id = dc.customer_unique_id
)

select * from final