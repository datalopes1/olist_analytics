with customers as (
    select * from {{ source('raw', 'customers') }}
),

final as (
    select
        customer_id,
        customer_unique_id,
        customer_zip_code_prefix,
        customer_state as uf,
        upper(customer_city) as cidade
    from customers
)

select * from final
