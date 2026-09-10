with reviews as (
    select * from {{ ref('stg_order_reviews') }}
),

final as (
select 
    {{ dbt_utils.generate_surrogate_key(['review_id', 'order_id']) }} as review_sk,
    review_id,
    order_id,
    review_dt,
    review_score
from reviews
)

select * from final