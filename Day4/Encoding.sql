CREATE TABLE if not exists optimized_transactions (
    transaction_id BIGINT ENCODE AZ64,
    customer_id BIGINT ENCODE AZ64,
    merchant_id BIGINT ENCODE AZ64,
    amount DECIMAL(10,2) ENCODE AZ64,
    payment_mode VARCHAR(20) ENCODE LZO,
    status VARCHAR(20) ENCODE BYTEDICT,
    transaction_time TIMESTAMP ENCODE DELTA
)
DISTSTYLE KEY
DISTKEY(customer_id)
SORTKEY(transaction_time);



COPY optimized_transactions
FROM 's3://rj-de-bucket/transactions.csv'
IAM_ROLE 'arn:aws:iam::751285160227:role/s3-redshift-role'
CSV
IGNOREHEADER 1
REGION 'ap-south-1';


SELECT *
FROM optimized_transactions;

-- VACUMM

DELETE FROM optimized_transactions
WHERE status='FAILED';

SELECT * FROM optimized_transactions;

VACUUM optimized_transactions;

-- ANALYZE

ANALYZE optimized_transactions;




