# dbt-slowly-changing-dimensions
Practical examples of Slowly Changing Dimensions (SCD Type 0, 1, and 2) using dbt and MySQL.

## Running Steps (Full Flow)

#### Start everything
```bash
docker compose up
```

### Test dbt connection
```bash
docker exec -it dbt_scd dbt debug
```

### First build (initial customers)
```bash
docker exec -it dbt_scd dbt build
```

### NOTE:
>mysql: [Warning] Using a password on the command line interface can be insecure.

<i>Passwords must not be shared in this way! This example is for educational and illustrative purposes only.</i>

### Check tables (after initial load)
```bash
docker exec -it mysql_scd mysql -u demo_user -pdemo_pass demo_db
```
```sql
select * from customers_scd0;
select * from customers_scd1;
select * from customers_scd2;
```

### Load updated customers
```bash
docker exec -i mysql_scd mysql -u root -proot demo_db < ./load_customers_updated.sql
```

### Second build (after updates)
```bash
docker exec -it dbt_scd dbt build
```

### Check tables again (after update)
```bash
docker exec -it mysql_scd mysql -u demo_user -pdemo_pass demo_db
```
```sql
select * from customers_scd0;
select * from customers_scd1;
select * from customers_scd2;
```