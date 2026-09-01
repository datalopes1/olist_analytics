with source as (
    select * from {{ ref('stg__order_payments') }}
),

final as (
    select
        order_id,
        payment_type,
        payment_installments,
        payment_value
    from source
)

select * from final
