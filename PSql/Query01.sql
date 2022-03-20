-- let's see when we need to use views.
-- 1. For security reasons.
-- Example
create role james
login
password 'james';
grant select on order_summary to james;

-- 2. For performance reasons.
-- 3. For simplifying complex queries.
----------------------------
-- Creating view
create or replace view order_summary as
select o.order_id,
       o.order_date,
       c.name,
       (d.quantity * d.price) - ((p.price * o.quantity)*disc_percent::float/100) as cost
from tb_customer_data c
join tb_order_details o on o.cust_id = c.cust_id
join tb_product_info p on p.product_id = o.product_id
-- When using create or replace command, you can't change order of columns or data types and column names
-- if order already exists.
-- To rename column.
alter view order_summary rename column cost to total_cost;
-- To delete view.
drop view order_summary;
-- If we will update original table, view won't see that change 
-- Example.
create view expensive_products
as
select * from tb_product_info where price > 1000;

select * from expensive_products;
alter table tb_product_info add column prod_config varchar(100);

select * from expensive_products;
-- above query will not change original result columns.
-- views containing group by are not automatically updated.
-- Example.
create view order_count
as 
select date, count(1) as no_of_order
from tb_order_details
group by date;

select * from order_count;

update order_count
set no_of_order = 0
where date = '2020-01-01';
-- above query will give error.
-- The same way if view contains
-- 1. With clause or window functions then we cannot update such views.
-- View query cannot have DISTINCT clause.
-- WITH CHECK OPTION Example
create or replace view apple_products
as 
select * from tb_product_info where name like '%apple%';
with check option ;

insert into apple_products
values ('p22', 'Note 22', 'Sumsung', 2500,null);

select * from apple_products;
-- above query will give error if view has WITH CHECK OPTION, without it it will work.

