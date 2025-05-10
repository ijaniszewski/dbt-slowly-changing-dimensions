{{ config(
    materialized='table'
) }}

with latest_source as (
    select
        customer_id,
        first_name,
        last_name,
        email,
        address,
        updated_at
    from {{ ref('stg_customers') }}
),

-- Detect "soft deletions": records that exist in the target but not in the source
-- Only run this part if the table already exists
deleted_customers as (
    {% if is_incremental() %}
    select
        t.customer_id,
        t.first_name,
        t.last_name,
        t.email,
        t.address,
        t.updated_at
    from {{ this }} t
    left join latest_source s
        on t.customer_id = s.customer_id
    where s.customer_id is null
    {% else %}
    select null as customer_id, null as first_name, null as last_name,
           null as email, null as address, null as updated_at
    where false
    {% endif %}
),

-- Keep the latest from source
ranked_customers as (
    select
        customer_id,
        first_name,
        last_name,
        email,
        address,
        updated_at,
        row_number() over (partition by customer_id order by updated_at desc) as rn
    from latest_source
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

union all

-- Add soft-deleted customers
select * from deleted_customers