with sellers as (
    select * from {{ ref('stg__sellers') }}
),

geolocations as (
    select
        zip_code_prefix,
        max(uf) as uf,
        max(cidade) as cidade
    from {{ ref('stg__geolocations') }}
    group by
        zip_code_prefix
),

final as (
    select
        sellers.seller_id,
        sellers.zip_code_prefix,
        geolocations.uf,
        geolocations.cidade
    from sellers
    inner join geolocations on sellers.zip_code_prefix = geolocations.zip_code_prefix
)

select * from final
