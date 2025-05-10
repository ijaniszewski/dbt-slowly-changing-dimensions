{{ config(
    materialized='incremental',
    unique_key='customer_id'
) }}

with incoming as (
    select
        customer_id,
        first_name,
        last_name,
        email,
        address,
        updated_at
    from {{ ref('stg_customers') }}
),

latest as (
    select *
    from {{ this }}
    where is_current = true
),

changes as (
    select
        i.customer_id,
        i.first_name,
        i.last_name,
        i.email,
        i.address,
        i.updated_at,
        current_timestamp as valid_from,
        null as valid_to,
        true as is_current
    from incoming i
    left join latest l
      on i.customer_id = l.customer_id
    where l.customer_id is null  -- new customer
       or i.email != l.email
       or i.address != l.address
       or i.first_name != l.first_name
       or i.last_name != l.last_name
)

select * from changes

{% if is_incremental() %}
union all

select
    customer_id,
    first_name,
    last_name,
    email,
    address,
    updated_at,
    valid_from,
    current_timestamp as valid_to,
    false as is_current
from {{ this }}
where is_current = true
and customer_id in (select customer_id from changes)
{% endif %}