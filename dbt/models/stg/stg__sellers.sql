with source as (
    select * from {{ source('db', 'sellers') }}
),

final as (
    select
        seller_id,
        seller_zip_code_prefix as zip_code_prefix
    from source
)

select * from final
