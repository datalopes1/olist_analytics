with order_reviews as (
    select * from raw.order_reviews
),

final as (
select 
    review_id,
    order_id,
    cast(review_creation_date as datetime) as review_dt,
    cast(review_score as signed) as review_score
from order_reviews
)

select * from final