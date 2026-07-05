DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    order_id      INT,
    order_date    DATE,
    customer_name VARCHAR(150),
    city          VARCHAR(100),
    state         VARCHAR(100),
    region        VARCHAR(50),
    country       VARCHAR(50),
    category      VARCHAR(100),
    sub_category  VARCHAR(100),
    product_name  VARCHAR(255),
    quantity      INT,
    unit_price    DECIMAL(10, 2),
    revenue       DECIMAL(10, 2),
    profit        DECIMAL(10, 2)
)

DISTSTYLE KEY
DISTKEY(order_id);

COPY orders
FROM 's3://rj-de-bucket/orders.csv'
IAM_ROLE 'arn:aws:iam::751285160227:role/s3-redshift-role'
CSV
IGNOREHEADER 1
DATEFORMAT 'auto'
REGION 'ap-south-1';


EXPLAIN 
SELECT * FROM orders WHERE order_id=1;


CREATE TABLE optimized_orders (
    order_id      INT,
    order_date    DATE,
    customer_name VARCHAR(150),
    city          VARCHAR(100),
    state         VARCHAR(100),
    region        VARCHAR(50),
    country       VARCHAR(50),
    category      VARCHAR(100),
    sub_category  VARCHAR(100),
    product_name  VARCHAR(255),
    quantity      INT,
    unit_price    DECIMAL(10, 2),
    revenue       DECIMAL(10, 2),
    profit        DECIMAL(10, 2)
)

DISTSTYLE KEY
DISTKEY(order_id)
SORTKEY(order_date);

COPY optimized_orders
FROM 's3://rj-de-bucket/orders.csv'
IAM_ROLE 'arn:aws:iam::751285160227:role/s3-redshift-role'
CSV
IGNOREHEADER 1
DATEFORMAT 'auto'
REGION 'ap-south-1';

EXPLAIN 
SELECT * FROM optimized_orders WHERE order_date = '2024-12-20';
VACUUM SORT ONLY optimized_orders;
ANALYZE optimized_orders;