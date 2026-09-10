with order_payments as (
    select * from {{ source('raw', 'order_payments') }}
),

final as (
    select
        order_id,
        payment_sequential,
        payment_installments,
        cast(payment_value as decimal(10, 2)) as payment_value,
        upper(replace(payment_type, '_', ' ')) as payment_type
    from order_payments
)

select * from final
