with source as (
    select * from {{ source('db', 'order_payments') }}
),

final as (
    select
        order_id,
        payment_installments,
        payment_sequential,
        payment_value,
        replace(upper(coalesce(payment_type, 'NOT DEFINED')), '_', ' ') as payment_type
    from source
)

select * from final
