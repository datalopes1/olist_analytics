with source as (
    select * from {{ source('db', 'products') }}
),

final as (
    select
        product_id,
        product_name_lenght,
        product_description_lenght,
        product_photos_qty,
        product_weight_g,
        product_length_cm,
        product_height_cm,
        product_width_cm,
        replace(upper(product_category_name), '_', ' ') as product_category
    from source
)

select * from final
