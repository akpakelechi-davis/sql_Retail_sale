create table Retail_sale (
                           transactions_id INT	PRIMARY KEY,
						   sale_date DATE,	
						   sale_time TIME,	
						   customer_id INT,	
						   gender VARCHAR(15),	
						   age	INT,
						   category	 VARCHAR(15),
						   quantity INT,	
						   price_per_unit FLOAT,	
						   cogs	FLOAT,
						   total_sale FLOAT

                          )
alter table Retail_sale
rename column quantiy to quantity

select * 
        from Retail_sale
--count the rows in this table
select 
count(*) from Retail_sale
--data cleaning
select * 
    from Retail_sale
where transactions_id is null
or
sale_date is null
or
sale_time is null
or
customer_id is null
or
gender is null
or
age is null
or
category is null
or
quantiy is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null


delete from Retail_sale
where transactions_id is null
or
sale_date is null
or
sale_time is null
or
customer_id is null
or
gender is null
or
age is null
or
category is null
or
quantiy is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null
--data Exploration
select count ( total_sale) from Retail_sale
--how many unique customer do we have
select count (distinct total_sale) from Retail_sale

select distinct category from Retail_sale

--Data Analysis & Business key Problem and |Answer

--My analysis & findings
--0.1	write a SQL query to retrieve all sales made on “2022-11-05
--0.2	write a SQL query to retrieve all transactions where the category is “clothing” and sold quantity is more than 10 in the month of Nov-2022
--0.3	Write a SQL query to calculate the total sale (total_sale) for each category
--0.4	Write a SQL query to find average age of customer who purchased items from the “Beauty” category
--0.5	Write a SQL query to find all transaction where the total_sales is greater than “1000”
--0.6	Write a SQL query to find the total number of transaction (transaction_id) made by each gender in each category
--0.7	Write a SQL query to calculate the average sale for each month, find out best selling month in each year
--0.8	Write a SQL query to find the top 5 customer based on the highest total sales
--0.9	Write a SQL query  to fine the number of unique customers who purchased items from each category 
--0.10	Write a SQL query to create each shift and number of orders (Example morning <= 12, Afternoon between 12 & 17, Evening >17)

--0.1	write a SQL query to retrieve all sales made on “2022-11-05
select * 
       from Retail_sale
	   where sale_date = '2022-11-05';


--0.2	write a SQL query to retrieve all transactions where the category is “clothing” and sold quantity is more than 4 in the month of Nov-2022

select 
      category,
	  sale_date,
	  quantity
from Retail_sale
where category = 'Clothing'
and 
TO_CHAR (sale_date, 'yyyy-mm') ='2022-11'
AND
quantity >= 4

--0.3	Write a SQL query to calculate the total sale (total_sale) for each category

select
      category,
      sum(total_sale)as net_sale,
	  count(*) as total_order
from Retail_sale
group by 1

--0.4	Write a SQL query to find average age of customer who purchased items from the “Beauty” category
select 
      round(avg(age), 2) as average_age
from Retail_sale
where category = 'Beauty'

--0.5	Write a SQL query to find all transaction where the total_sales is greater than “1000”
select
      *
from Retail_sale
where total_sale > 1000,


--0.6	Write a SQL query to find the total number of transaction (transaction_id) made by each gender in each category


select 
      category,
	  gender,
	  count(*) as total_transaction
from Retail_sale
group
    by
	 category,
	 gender
order by 1

--0.7	Write a SQL query to calculate the average sale for each month, find out best selling month in each year

SELECT 
    year,
    month,
    avg_sale
FROM (
    SELECT
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rank
    FROM Retail_sale
    GROUP BY 1, 2
) t1
WHERE rank = 1;




--0.8	Write a SQL query to find the top 5 customer based on the highest total sale	

select 
     customer_id,
	 sum(total_sale) as highest_sale
from Retail_sale
group by 1
order by 2 desc
limit 5

--0.9	Write a SQL query  to fine the number of unique customers who purchased items from each category 


select
      category,
	 count( distinct customer_id) as unique_customer
from Retail_sale
group by 1


--0.10	Write a SQL query to create each shift and number of orders (Example morning <= 12, Afternoon between 12 & 17, Evening >17)
with hourly_sale
as
(

select*,
   case
        when extract(hour from sale_time)<12 then 'morning'
		when extract(hour from sale_time) between 12 and 17  then 'afternoon'
	else 'evening'
	end as shift
from Retail_sale
)
select
     shift,
	 count(*) as total_order

from hourly_sale
group by shift

--end of project