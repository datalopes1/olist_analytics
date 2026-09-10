with source as (
    select * from {{ ref('stg_products') }}
),

final as (
    select
        product_id,
        product_category
    from source
)

select * from final
