with source as (
    select * from {{ source('db', 'order_reviews') }}
),

final as (
    select
        review_id,
        order_id,
        review_comment_title as review_title,
        review_comment_message as review_message,
        review_creation_date as review_dt,
        review_answer_timestamp as review_answer_ts,
        review_score
    from source
)

select * from final
