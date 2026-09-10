with customers as (
    select * from {{ ref('stg_customers') }}
),

orders as (
    select * from stg_orders
),

clean as (
    select
        c.customer_unique_id,
        c.customer_zip_code_prefix,
        c.uf,
        c.cidade,
        row_number() over (partition by c.customer_unique_id order by o.approved_at desc nulls last) as rn
    from customers as c
    left join orders as o on c.customer_id = o.customer_id
),

final as (
    select
        customer_unique_id,
        customer_zip_code_prefix,
        uf,
        cidade
    from clean
    where rn = 1
)

select * from final
