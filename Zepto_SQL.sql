drop table if exists Zepto;
create table Zepto(
sku_id serial primary key,
catagory varchar(120),
name varchar(120) not null,
mrp numeric(8,2),
discountPercent numeric(5,2),
availableQuantity int,
discountSellingPrice numeric(8,2),
weightInGms int,
outOfStock boolean,
quantity int

);
--data exploration

-- count rowa
 select count(*) from Zepto;

select * from Zepto limit 10;

select * from Zepto
where name is null
or
 catagory is null
or
 mrp is null
or
 discountPercent is null
or
 availableQuantity is null
or
 discountSellingPrice is null
or
 weightInGms is null
or
 outOfStock is null
or
 weightInGms is null
or
 quantity is null

 -- different product Category
 select DISTINCT catagory
  from Zepto
  group by catagory;

 -- count instock and outStock of product
 select outOfstock, count(name)
 from Zepto
 group by outOfstock;

 --product name present multipule times
select name, count(sku_id) as "Number of products"
 from Zepto
 group by name
 having count(sku_id)>1 
 order by count(sku_id) desc;

-- Data cleanig


-- product with price Zero
  select * from Zepto
  where mrp=0 or discountSellingPrice=0;
delete from Zepto where mrp=0;

-- convert the pisa to rupees
update zepto
 set mrp=mrp/100.0,
 discountSellingPrice=discountSellingPrice/100.0;

 select mrp,discountSellingPrice from Zepto;

 -- lets discuss dome business questions
 
 --1.Find the top 10 best-value products based on the discount percentage.
  SELECT name, mrp, discountPercent
FROM Zepto
order by discountPercent desc
LIMIT 10;

-- product with high mrp but out_of_stock
select name, mrp,outOfstock
from Zepto
where outOfstock='TRUE'
order by mrp desc;

--Calculate estimated revenue for each category.
SELECT 
    catagory,
    SUM(discountSellingPrice * availableQuantity) AS estimatedRevenue
FROM Zepto
GROUP BY catagory
ORDER BY estimatedRevenue DESC;


--Find all products where MRP is greater than ₹500 and discount is less than 10%.
select name, mrp,discountPercent
from Zepto
where mrp > 500 and  discountPercent < 10
order by mrp desc;

--Identify the top 5 categories offering the highest average discount percentage.
SELECT 
    catagory,
    AVG(discountPercent) AS avgDiscount
FROM Zepto
GROUP BY catagory
ORDER BY avgDiscount DESC
LIMIT 5;


--Find the price per gram for products above 100g and sort by best value.
SELECT 
    name,
    weightInGms,
    discountSellingPrice,
    ROUND(discountSellingPrice / weightInGms, 4) AS price_per_gram
FROM Zepto
WHERE weightInGms > 100
ORDER BY price_per_gram ASC;

--Group the products into categories like Low, Medium, Bulk.
SELECT
    name,
    weightInGms,
    CASE
        WHEN weightInGms <= 250 THEN 'Low'
        WHEN weightInGms BETWEEN 251 AND 1000 THEN 'Medium'
        ELSE 'Bulk'
    END AS product_category
FROM Zepto;

--What is the total inventory weight per category?
SELECT
    catagory,
    SUM(weightInGms * availableQuantity) AS total_inventory_weight_gms
FROM Zepto
GROUP BY catagory
ORDER BY total_inventory_weight_gms DESC;


 






 