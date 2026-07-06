-- Redshift connected:
-- Glue Catalog ↔ Spectrum ↔ S3

CREATE EXTERNAL SCHEMA spectrum_schema
FROM DATA CATALOG
DATABASE 'spectrum_db'
IAM_ROLE 'arn:aws:iam::751285160227:role/s3-redshift-role'
CREATE EXTERNAL DATABASE IF NOT EXISTS;


-- This table: does NOT store data in Redshift
 -- Only metadata stored.

--  Actual data remains: inside S3


CREATE EXTERNAL TABLE spectrum_schema.customers (
    customer_id BIGINT,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    total_spent BIGINT
)

PARTITIONED BY (
    year INT,
    month INT
)

ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION 's3://rj-de-bucket/spectrum/';


-- Query from s3 data
SELECT *
FROM spectrum_schema.customers;