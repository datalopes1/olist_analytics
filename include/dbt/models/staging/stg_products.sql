with products as (
    select * from raw.products
),

final as (
select  
    product_id,
    upper(replace(product_category_name, '_', ' ')) as product_category,
    cast(product_name_lenght as signed) as product_name_lenght,
    cast(product_description_lenght as signed) as product_description_lenght,
    cast(product_photos_qty as signed) as product_photos_qty,
    cast(product_weight_g as decimal(10, 2)) as product_weight_g,
    cast(product_length_cm as decimal(10, 2)) as product_length_cm,
    cast(product_height_cm as decimal(10, 2)) as product_height_cm,
    cast(product_width_cm as decimal(10, 2)) as product_width_cm
from products
)

select * from final