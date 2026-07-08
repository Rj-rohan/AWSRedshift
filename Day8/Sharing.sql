-- Data Sharing?
-- Allows: live data sharing between clusters/accounts

CREATE DATASHARE sales_share;

-- 1. Add the schema to the datashare first
ALTER DATASHARE sales_share ADD SCHEMA public;

-- 2. Then add your table
ALTER DATASHARE sales_share ADD TABLE transactions;

-- 3. Granting the permission
GRANT USAGE
ON DATASHARE sales_share
TO NAMESPACE 'cfe1ddbb-c1c1-43e8-993b-cfeea68d5c55';
