LOAD DATA INFILE '/var/lib/mysql-files/customers_updated.csv'
REPLACE
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(customer_id, first_name, last_name, email, address, updated_at);