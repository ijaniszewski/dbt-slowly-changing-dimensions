select
  customer_id,
  first_name,
  last_name,
  email,
  address,
  updated_at
from {{ source('demo_db', 'customers') }}