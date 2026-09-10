with source as (
    select * from {{ ref('stg_sellers') }}
),

final as (
    select
        {{ dbt_utils.generate_surrogate_key(['seller_id']) }} as seller_sk,
        seller_id,
        seller_zip_code_prefix,
        uf,
        cidade
    from source
)

select * from final
