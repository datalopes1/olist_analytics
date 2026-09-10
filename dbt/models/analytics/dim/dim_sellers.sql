with source as (
    select * from {{ ref('stg_sellers') }}
),

final as (
    select
        seller_id,
        seller_zip_code_prefix,
        uf,
        cidade
    from source
)

select * from final
