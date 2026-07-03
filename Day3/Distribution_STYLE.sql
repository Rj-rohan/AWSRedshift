
-- Create Schema for customers table

CREATE TABLE customers(
    customer_id INT ,
    customer_name VARCHAR(20),
    city VARCHAR(20),
    signup_date DATE
)

DISTSTYLE KEY
DISTKEY(customer_id);

-- Create Schema for transactions table

CREATE TABLE transactions(
    transaction_id BIGINT,
    customer_id BIGINT,
    merchant_id BIGINT,
    amount DECIMAL(10,2),
    payment_mode VARCHAR(20),
    status VARCHAR(20),
    transaction_time TIMESTAMP
)

DISTSTYLE KEY
DISTKEY(customer_id) 
SORTKEY(transaction_time);


-- Load data from S3 for customers table 

COPY customers
FROM 's3://rj-de-bucket/customers.csv'
IAM_ROLE 'arn:aws:iam::751285160227:role/s3-redshift-role'
CSV
IGNOREHEADER 1
REGION 'ap-south-1';

-- Load data from S3 for transactions table 

COPY transactions
FROM 's3://rj-de-bucket/transactions.csv'
IAM_ROLE 'arn:aws:iam::751285160227:role/s3-redshift-role'
CSV 
IGNOREHEADER 1
REGION 'ap-south-1';

-- Query 1 - Customer Revenue

SELECT
    c.customer_name,
    SUM(t.amount) AS total_spent
FROM customers c
JOIN transactions t
ON c.customer_id = t.customer_id
WHERE t.status='SUCCESS'
GROUP BY c.customer_name
ORDER BY total_spent DESC;

-- Query 2 — Time-Based Analytics

SELECT
    DATE(transaction_time),
    SUM(amount)
FROM transactions
WHERE status='SUCCESS'
GROUP BY DATE(transaction_time);

-- Query 3 — Payment Mode Analytics

SELECT
    payment_mode,
    COUNT(*),
    SUM(amount)
FROM transactions
GROUP BY payment_mode;

-- Query 4 — Failed Transactions

SELECT *
FROM transactions
WHERE status='FAILED';

-- Query 5 — Top Customers
SELECT
    customer_id,
    SUM(amount) total_amount
FROM transactions
GROUP BY customer_id
ORDER BY total_amount DESC
LIMIT 5;
