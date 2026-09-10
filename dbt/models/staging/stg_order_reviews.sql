with order_reviews as (
    select * from {{ source('raw', 'order_reviews') }}
),

final as (
    select
        review_id,
        order_id,
        cast(review_creation_date as timestamp) as review_dt,
        cast(review_score as integer) as review_score
    from order_reviews
)

select * from final
