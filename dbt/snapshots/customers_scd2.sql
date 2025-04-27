{% snapshot customers_scd2 %}

{{
  config(
    target_schema='demo_db',
    unique_key='customer_id',
    strategy='timestamp',
    updated_at='updated_at'
  )
}}

select
  customer_id,
  first_name,
  last_name,
  email,
  address,
  updated_at
from {{ ref('stg_customers') }}

{% endsnapshot %}