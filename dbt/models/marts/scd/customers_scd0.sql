{{ config(
    materialized='incremental',
    unique_key='customer_id'
) }}

select
  customer_id,
  first_name,
  last_name,
  email,
  address,
  updated_at
from {{ ref('stg_customers') }}

{% if is_incremental() %}
  where customer_id not in (select customer_id from {{ this }})
{% endif %}
