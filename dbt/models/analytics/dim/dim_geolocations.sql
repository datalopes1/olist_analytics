with source as (
    select * from {{ ref('stg_geolocation') }}
),

ranked as (
    select
        zip_code_prefix,
        uf,
        cidade,
        row_number() over (partition by zip_code_prefix order by uf, cidade) as rn
    from source
),

final as (
    select
        zip_code_prefix,
        uf,
        cidade
    from ranked
    where rn = 1
)

select * from final
