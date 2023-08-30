-- Sales Insights Data Analysis Project

-- Show all Tables in Sales Database.
Use sales;
show tables;

-- Handling some garbage values in transaction table(Deleting "-1" value in Sales_amount field which is an garbage value).
delete from transactions
where sales_amount = -1;

-- In Sales field some values are in USD so we have to UPDATE it into INR.
update  transactions
set sales_amount = sales_amount*82.62
where currency = 'USD';

-- Show all customer Information.
select * from customers;

-- Show total number of customers.
SELECT count(*) as CountOfCustomers FROM customers;

-- Total Revenue in million.
select concat(round(sum(sales_amount) /1000000,2), 'M') as Total_Revenue 
from transactions;

-- Total Revenue in each year.
select year(order_date) as year, concat(round((sum(sales_amount)/1000000),2)," ","M") as Revenue
from transactions
group by 1;

-- Year on Year sales Percentage of the company.
select year(order_date) as Year , sum(sales_amount) as Total_Each_Year, 
round((sum(sales_amount) - lag(sum(sales_amount)) 
over(order by year(order_date)))/sum(sales_amount)*100,2 ) as YOY_Percent
from transactions
group by year(order_date);

-- Total No of products that selling in market
select count(product_code) as No_of_Products from products;

-- Which month gives high Revenue.
select monthname(order_date) Month, sum(sales_amount) as Monthly_Revenue
from transactions
group by monthname(order_date)
order by 2 desc;

-- Strongest market City based on SALES .
select a.market_name , sum(sales_amount) as Sales_Per_City 
from transactions b 
inner join markets a using(market_code)
group by a.market_name
order by Sales_Per_City desc
limit 5;

-- Weakest market based on SALES.
select b.market_name,sum(sales_amount) as Revenue 
from transactions a inner join markets b using(market_code)
group by market_code
order by 2
limit 5;

-- Sales Based Region-wise in million.
select a.zone , concat(round((sum(b.sales_amount) / 1000000),0)," ","M") as Revenue_region
from markets a inner join transactions b using(market_code)
group by a.zone
order by  sum(b.sales_amount) desc;

-- Which product selling most whether Own Product Or Distribution Product.
select  a.product_type, sum(b.sales_amount) as Revenue_Product_Type
from products a inner join transactions b using(product_code)
group by 1
order by 2 desc;

-- Top selling Product .
select a.product_code,sum(a.sales_amount) as Total_sales, b.product_type
from transactions a inner join products b using(product_code)
group by product_code
order by sum(a.sales_amount) desc
limit 5;

-- Total Profit by the company in million.
select concat(round(sum(Profit) /1000000,2), 'M') as Total_Revenue 
from transactions;

-- Year on Year Profit Growth
select year(order_date) as Year , round(sum(Profit),2) as Profit_Each_Year, 
round((sum(Profit) - lag(sum(Profit)) 
over(order by year(order_date)))/sum(Profit)*100,2 ) as YOY_Percent
from transactions
group by year(order_date);

-- Top 5 profitable City.
select b.market_name , ROUND(sum(profit),2) as Total_Profit 
from transactions a inner join markets b using(market_code)
group by 1
order by 2 DESC
limit 5 ;

-- Bottom 5 profitable City.
select b.market_name , ROUND(sum(profit),2) as Total_Profit 
from transactions a inner join markets b using(market_code)
group by 1
order by 2 
limit 5 ;

-- Top 10 Pofitable products.
select product_code , concat(round(sum(sales_amount)/1000000,2),"m") as Profits
from transactions
group by 1 
order by sum(sales_amount) desc
limit 10;

-- Bottom 10 Pofitable products.
select product_code , concat(round(sum(sales_amount)/1000000,2),"m") as Profits
from transactions
group by 1 
order by sum(sales_amount) asc
limit 10;

-- Top Customers.
with Top_customer as (select b.customer_code,a.custmer_name as customer_name,sum(b.sales_amount) as Revenue 
from customers a inner join transactions b using(customer_code)
group by b.customer_code
order by 3 desc)
select customer_name from Top_customer
limit 5;

-- Analyzing Chennai Market 

-- Show transactions for Chennai market (market code for chennai is Mark011).
select * from transactions
where market_code = 'Mark001';

-- Total Revenue in chennai market.
select concat(round(sum(sales_amount)/1000000,2)," ","M") as Chennai_Revenue
from transactions
where market_code = 'Mark001';

-- Show distrinct product codes that were sold in chennai
SELECT distinct product_code 
FROM transactions 
where market_code='Mark001';

-- Top 10 product codes that were sold in chennai.
select product_code as Top_Products_Chennai, sum(sales_amount) as Revenue 
from transactions
where market_code = 'Mark001'
group by product_code
order by Revenue desc
limit 10;

-- YOY growth on chennai.
select year(order_date) as Year, sum(sales_amount) as Revenue,
round((sum(sales_amount) - 
lag(sum(sales_amount)) over(order by year(order_date)))/sum(sales_amount)*100,2)  as   YOY
from transactions 
where market_code = 'Mark001'
group by 1;



