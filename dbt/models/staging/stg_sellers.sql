with sellers as (
    select * from {{ source('raw', 'sellers') }}
),

final as (
    select
        seller_id,
        seller_zip_code_prefix,
        seller_state as uf,
        upper(seller_city) as cidade
    from sellers
)

select * from final
