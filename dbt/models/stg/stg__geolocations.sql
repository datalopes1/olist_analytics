with source as (
    select * from {{ source('db', 'geolocation') }}
),

final as (
    select
        geolocation_zip_code_prefix as zip_code_prefix,
        geolocation_state as uf,
        geolocation_lat as latitude,
        geolocation_lng as longitude,
        upper(geolocation_city) as cidade
    from source
)

select * from final
