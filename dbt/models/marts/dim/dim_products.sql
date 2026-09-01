with source as (
    select * from {{ ref('stg__products') }}
),

final as (
    select
        product_id,
        product_category
    from source
)

select * from final
