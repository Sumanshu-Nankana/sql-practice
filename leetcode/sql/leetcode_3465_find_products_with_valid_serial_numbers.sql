-- Create Table
CREATE TABLE If not exists products (
    product_id INT,
    product_name VARCHAR(255),
    description VARCHAR(255)
);

-- Insert Data
Truncate table products;
insert into products (product_id, product_name, description) values ('1', 'Widget A', 'This is a sample product with SN1234-5678');
insert into products (product_id, product_name, description) values ('2', 'Widget B', 'A product with serial SN9876-1234 in the description');
insert into products (product_id, product_name, description) values ('3', 'Widget C', 'Product SN1234-56789 is available now');
insert into products (product_id, product_name, description) values ('4', 'Widget D', 'No serial number here');
insert into products (product_id, product_name, description) values ('5', 'Widget E', 'Check out SN4321-8765 in this description');

-- Write your PostgreSQL query statement below
SELECT product_id, product_name, description
FROM products where REGEXP_LIKE(description, '(^|\s)SN[0-9]{4}-[0-9]{4}([^0-9]|$)')
ORDER BY product_id
