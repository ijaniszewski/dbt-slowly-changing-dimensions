{{ config(
    materialized='table'
) }}

with ranked_customers as (
    select
        customer_id,
        first_name,
        last_name,
        email,
        address,
        updated_at,
        row_number() over (partition by customer_id order by updated_at desc) as rn
    from {{ ref('stg_customers') }}
)

select
    customer_id,
    first_name,
    last_name,
    email,
    address,
    updated_at
from ranked_customers
where rn = 1
