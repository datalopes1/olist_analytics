with geolocation as (
    select * from raw.geolocation
),

final as (
select 
    geolocation_zip_code_prefix as zip_code_prefix,
    geolocation_lat as latitude,
    geolocation_lng as longitude,
    geolocation_state as uf,
    upper(geolocation_city) as cidade
from geolocation
)

select * from final