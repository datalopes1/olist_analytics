with source as (
    select * from {{ source('db', 'customers') }}
),

final as (
    select
        customer_id,
        customer_unique_id,
        customer_zip_code_prefix as zip_code_prefix
    from source
)

select * from final
