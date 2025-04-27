CREATE TABLE customers (
  customer_id INT PRIMARY KEY,
  first_name VARCHAR(255),
  last_name VARCHAR(255),
  email VARCHAR(255),
  address VARCHAR(255),
  updated_at DATE
);

LOAD DATA INFILE '/var/lib/mysql-files/customers_initial.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(customer_id, first_name, last_name, email, address, updated_at);


-- Allow demo_user select access
GRANT SELECT ON customers TO 'demo_user'@'%';

-- Apply privilege changes
FLUSH PRIVILEGES;