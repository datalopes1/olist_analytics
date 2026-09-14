with reviews as (
    select * from {{ ref('stg_order_reviews') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
),

customers as (
    select * from {{ ref('stg_customers') }}
),

review as (
select 
    re.review_id,
    re.order_id,
    cs.customer_unique_id,
    re.review_dt,
    re.review_score
from reviews re
left join orders od on re.order_id = od.order_id
left join customers cs on od.customer_id = cs.customer_id
),

final as (
select
    re.review_id,
    re.order_id,
    {{ dbt_utils.generate_surrogate_key(['re.order_id', 're.review_id']) }} as payment_sk,
    dc.customer_sk,
    re.review_dt,
    re.review_score
from review re
left join {{ ref('dim_customers') }} dc on re.customer_unique_id = dc.customer_unique_id
)

select * from final 