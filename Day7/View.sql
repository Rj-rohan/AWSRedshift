-- Querying data
SELECT * FROM transactions;

-- Create MATERIALIZED View to store physical data
CREATE MATERIALIZED VIEW mv_Customer_spending AS
SELECT 
      customer_id,
      SUM(amount) total_spent
FROM transactions
GROUP BY customer_id;

-- Query Materialized View

SELECT *
FROM mv_customer_spending;


-- Insert data 
INSERT INTO transactions VALUES
(5055,178,9058,3000,'UPI','SUCCESS','08-08-2026 10:00:00');

-- Query MATERIALIZED VIEW Again but data is still old
-- New transaction NOT reflected yet.

SELECT *
FROM mv_customer_spending;

-- Refresh View to reflect that changes
REFRESH MATERIALIZED VIEW mv_customer_spending;

-- Query Again
SELECT *
FROM mv_customer_spending;


