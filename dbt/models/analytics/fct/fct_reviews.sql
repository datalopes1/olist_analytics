with reviews as (
    select * from {{ ref('stg_order_reviews') }}
),

final as (
select 
    r.review_id,
    r.order_id,
    {{ dbt_utils.generate_surrogate_key(['r.review_id', 'r.order_id']) }} as review_sk,
    dc.customer_sk,
    r.review_dt,
    r.review_score
from reviews r
left join {{ ref('stg_orders') }} o on r.order_id = o.order_id
left join {{ ref('stg_customers') }} c on o.customer_id = c.customer_id
left join {{ ref('dim_customers') }} dc on c.customer_unique_id = dc.customer_unique_id
)

select * from final