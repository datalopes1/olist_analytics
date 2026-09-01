with customers as (
    select * from {{ref('stg__customers')}}
),

geolocations as (
    select
        zip_code_prefix,
        max(uf) as uf,
        max(cidade) as cidade
    from {{ref('stg__geolocations')}}
    group by
        zip_code_prefix
),

final as (
    select
        customers.customer_id,
        customers.customer_unique_id,
        customers.zip_code_prefix,
        geolocations.uf,
        geolocations.cidade
    from customers
    left join geolocations on customers.zip_code_prefix = geolocations.zip_code_prefix
)

select * from final
