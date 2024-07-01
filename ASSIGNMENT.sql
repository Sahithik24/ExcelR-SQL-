use classicmodels;
# day-3 assignment
#1)Show customer number, customer name, state and credit limit from customers table for below conditions. 
#Sort the results by highest to lowest values of creditLimit.
#State should not contain null values
#credit limit should be between 50000 and 100000
select customerNumber,customerName,state,creditLimit
from customers
where state IS NOT NULL and 
creditLimit between '50000' and '100000'
order by creditLimit desc;

#2)Show the unique productline values containing the word cars at the end from products table.
select distinct productLine from products
where productLine like '_%cars';

#Day 4
#1)Show the orderNumber, status and comments from orders table for shipped status only. 
#If some comments are having null values then show them as “-“. 

select orderNumber,status,
case 
   when comments IS null then '-'
   else comments
end as comments
from orders
where status='shipped';

#2)Select employee number, first name, job title and job title abbreviation from employees table based on following conditions.
#If job title is one among the below conditions, then job title abbreviation column should show below forms.
#President then “P”
#Sales Manager / Sale Manager then “SM”
#Sales Rep then “SR”
#Containing VP word then “VP”
select employeeNumber,firstName,jobTitle,
case
      when jobTitle='president' then "p"
      WHEN jobTitle='sale Manager (EMEA)'then "SM"
      WHEN jobTitle='Sales Manager (APAC)'then "SM"
      WHEN jobTitle='Sales Manager (NA)'then "SM"
      WHEN jobTitle='Sales Rep' then "SP"
      WHEN jobTitle='VP' THEN "VP"
END AS JOBTITLE_ABBREVIATION
from employees
where jobTitle in('PRESIDENT','sale Manager (EMEA)','Sales Manager (APAC)','Sales Manager (NA)','Sales Rep','VP');

select employeeNumber,firstName,jobTitle,
case
      when jobTitle='president' then "p"
      WHEN jobTitle like 'sale Manager%' or jobTitle like 'Sales Manager%' then "SM"
      WHEN jobTitle='Sales Rep' then "SP"
      WHEN jobTitle like 'VP%' THEN "VP"
END AS JOBTITLE_ABBREVIATION
from employees
where jobTitle in('PRESIDENT','sale Manager (EMEA)','Sales Manager (APAC)','Sales Manager (NA)','Sales Rep','VP');

#Day 5:
#1)For every year, find the minimum amount value from payments table.

select distinct year(paymentDate) AS Year,min(amount) as Min_Amount
from payments
group by Year
order by Year asc;

#2)For every year and every quarter, find the unique customers and total orders from orders table.
# Make sure to show the quarter as Q1,Q2 etc.
#query 1
select year(orderDate) order_Year,
case
  when quarter(orderDate)=1 then "Q1" 
  when quarter(orderDate)=2 then "Q2" 
  when quarter(orderDate)=3 then "Q3" 
  when quarter(orderDate)=4 then "Q4" 
end as order_Quarter,
count(distinct customerNumber) as Unique_Customer, count(*) as Total_orders
from orders
group by order_Year,order_Quarter
order by order_Year,order_Quarter;

#3)Show the formatted amount in thousands unit (e.g. 500K, 465K etc.) for every month (e.g. Jan, Feb etc.)
# with filter on total amount as 500000 to 1000000. Sort the output by total amount in descending mode. [ Refer. Payments Table]
select monthname(paymentDate) as month,concat(format(sum(amount)/1000,0),'k') as formatted_amount
from payments
group by 1
having sum(amount) between 500000 and 1000000
order by sum(amount) desc;

select date_format(paymentDate,'%b') as month,concat(format(sum(amount)/1000,0),'k') as formatted_amount
from payments
group by 1
having sum(amount) between 500000 and 1000000
order by sum(amount) desc;

##Day 6:
#1)Create a journey table with following fields and constraints.
#●Bus_ID (No null values)
#●Bus_Name (No null values)
#●Source_Station (No null values)
#●Destination (No null values)
#●Email (must not contain any duplicates)
drop table if exists `journey`;
create table `journey` (
   Bus_ID int NOT NULL,
   Bus_Name varchar(25) NOT NULL,
   Source_Station varchar(25) NOT NULL,
   Destination varchar(25) NOT NULL,
   Email varchar(25) NOT NULL UNIQUE
   )
  
#2)Create vendor table with following fields and constraints.
#●Vendor_ID (Should not contain any duplicates and should not be null)
#●Name (No null values)
#●Email (must not contain any duplicates)
#●Country (If no data is available then it should be shown as “N/A”)
drop table if exists vendor;
create table vendor (
  Vendor_ID int NOT NULL UNIQUE,
  Name varchar(25) NOT NULL,
  Email varchar(25) unique,
  Country varchar(50) DEFAULT 'N/A'
  )
  
#3)Create movies table with following fields and constraints.
#Movie_ID (Should not contain any duplicates and should not be null)
#Name (No null values)
#Release_Year (If no data is available then it should be shown as “-”)
#Cast (No null values)
#Gender (Either Male/Female)
#No_of_shows (Must be a positive number)
drop table if exists movies;
create table movies ( 
     Movie_ID int NOT NULL UNIQUE,
     Name varchar(50) NOT NULL,
     Release_Year varchar(4) default '-',
     Cast varchar(50) NOT NULL,
     Gender ENUM('FEMALE','MALE') ,
     No_of_shows int check(No_of_shows>0)
     )
     
DROP TABLE IF EXISTS PRODUCT;
create table product ( 
product_id INT auto_increment primary key,
product_name varchar(50) NOT NULL UNIQUE,
description text,
supplier_id int,
foreign key(supplier_id) references suppliers (supplier_id)
)

drop table if exists suppliers;
create table suppliers(
supplier_id int,
supplier_name varchar(50),
location varchar(50),
primary key(supplier_id)
)

drop table if exists stock;
create table stock(
id int auto_increment primary key,
product_id int,
balance_stock int,
foreign key(product_id) references product(product_id)
)

#Day 7
#1)Show employee number, Sales Person (combination of first and last names of employees), 
#unique customers for each employee number and sort the data by highest to lowest unique customers.
#Tables: Employees, Customers
select e.employeenumber as employee_number,concat(e.firstname,' ',e.lastname) as sales_person,
count(distinct c.customernumber) as unique_customers
from employees e
join customers c on
e.employeenumber=c.salesRepEmployeeNumber
group by employee_number,sales_person
order by  unique_customers desc;
#2)Show total quantities, total quantities in stock, left over quantities for each product and each customer. 
-- Sort the data by customer number.
-- Tables: Customers, Orders, Orderdetails, Products
select * from customers;
select * from orders;
select * from orderdetails;
select * from products;
 select c.customernumber,c.customername,p.productcode,p.productname,
 sum(od.quantityordered) as ordered_qty,p.quantityinstock as total_inventory,
 (p.quantityinstock-sum(od.quantityordered)) as left_qty
 from customers c
 join orders o on c.customernumber=o.customernumber
 join orderdetails od on o.ordernumber=od.ordernumber 
 join products p on p.productcode=od.productcode
 group by 1,2,3,4,6
 order by customernumber;
 
#3)Create below tables and fields. (You can add the data as per your wish)
#Laptop: (Laptop_Name)
#Colours: (Colour_Name)
#Perform cross join between the two tables and find number of rows.
#creating laptop table
create table Laptop (
Laptop_Name varchar(25)
);
insert into Laptop (Laptop_Name)
values('DELL');
#CREATING COLOURS TABLE
create table Colours (
Colour_Name varchar(25)
);
insert into Colours (Colour_Name) 
values ('White'),('Silver'),('Black');
select l.Laptop_Name,c.Colour_Name
from Colours c 
cross join Laptop l;

-- 4)Create table project with below fields.
-- ●EmployeeID
-- ●FullName
-- ●Gender
-- ●ManagerID
CREATE TABLE PROJECT ( 
EMPLOYEEID INT,
FULLNAME VARCHAR(50),
GENDER VARCHAR(10),
MANAGERID INT );
INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3);
INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);
INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);

SELECT * FROM PROJECT;
select m.fullname as managername, p.fullname as employeename 
from project m 
join project p 
on m.employeeid = p.managerid;

-- Day 8
-- Create table facility. Add the below fields into it.
-- ●Facility_ID
-- ●Name
-- ●State
-- ●Country
-- i) Alter the table by adding the primary key and auto increment to Facility_ID column.
-- ii) Add a new column city after name with data type as varchar which should not accept any null values.
DROP TABLE if exists  facility ;
create table facility ( 
Facility_ID int ,
Name varchar(100) ,
State varchar(100) ,
Country varchar(100) 
);

alter table facility 
   modify column Facility_ID int primary key auto_increment;
   
alter table facility 
   ADD COLUMN City varchar(100) not null AFTER  Name;
   describe facility ;
   
-- Day 9
-- Create table university with below fields.
-- ●ID
-- ●Name
-- Add the below data into it as it is.
-- INSERT INTO University
-- VALUES (1, "       Pune          University     "), 
--                (2, "  Mumbai          University     "),
--               (3, "     Delhi   University     "),
--               (4, "Madras University"),
--               (5, "Nagpur University");
-- Remove the spaces from everywhere and update the column like Pune University etc.

create table university ( 
id int,
name varchar(50) );

INSERT INTO University
VALUES (1, "       Pune          University     "), 
               (2, "  Mumbai          University     "),
              (3, "     Delhi   University     "),
              (4, "Madras University"),
              (5, "Nagpur University");
              
select * from university;

delete from University  
where name = puneUniversity;

update university 
set name = replace (name, ' ', ' ');

-- Day 10
-- Create the view products status. Show year wise total products sold. 
-- Also find the percentage of total value for each year. 
use classicmodels;
DROP VIEW IF EXISTS product_status;
CREATE VIEW product_status as
SELECT
   YEAR(paymentDate) AS Year,
   sum(amount) as totalvalue,
    (SUM(amount)/
    (SELECT SUM(amount) 
    FROM payments 
    WHERE YEAR(paymentDate) = YEAR(paymentDate))) * 100 AS Percentage_totalValue
FROM payments
GROUP BY Year
ORDER BY Year;

select * from product_status;

-- Day 11
-- 1)Create a stored procedure GetCustomerLevel which takes input as customer number 
-- and gives the output as either Platinum, Gold or Silver as per below criteria.
-- Table: Customers
-- ●Platinum: creditLimit > 100000
-- ●Gold: creditLimit is between 25000 to 100000
-- ●Silver: creditLimit < 25000
DROP PROCEDURE IF EXISTS  GetCustomerLevel;
 DELIMITER //
CREATE PROCEDURE GetCustomerLevel(
       in cutomernumber int , 
	   out creditlevel varchar(25) 
)
BEGIN
DECLARE xcredit DEC(10,2) DEFAULT 0;
SELECT 
	creditLimit INTO xcredit
    FROM customers
    WHERE 
		customerNumber = customerNumber;
set creditlevel = CASE 
			WHEN creditlimit < 25000 THEN 'Silver' 
            WHEN creditlimit BETWEEN 25000 AND  100000 THEN 'Gold' 
            WHEN creditlimit > 100000 THEN 'Platinum'
		END;
END //
DELIMITER ;
CALL GetCustomerLevel(@customernumber,@creditlevel);
SELECT @CustomerNumber,@creditlevel FROM customers
WHERE customerNumber = 103;
SELECT customernumber,creditlimit FROM CUSTOMERS;
-- 2)Create a stored procedure Get_country_payments which takes in year and 
-- country as inputs and gives year wise, country wise total amount as an output. 
-- Format the total amount to nearest thousand unit (K)
-- Tables: Customers, Payments

delimiter $$
create procedure Get_country_payments(
in inputyear int,
in inputcountry varchar(50)
)
begin 
select year(p.paymentdate) as year, c.country as country, CONCAT(FORMAT(SUM(p.amount)/1000, 0), 'K') as total_amount
from customers c
join payments p 
on c.customernumber = p.customernumber
where year(p.paymentdate) = inputyear and c.country = inputcountry
group by year, country;
end $$
delimiter ;

call Get_country_payments(2003,'france');

-- Day 12
-- 1)Calculate year wise, month name wise count of orders and year over year (YoY) percentage change. 
-- Format the YoY values in no decimals and show in % sign.
-- Table: Orders
-- select year(orderdate) as Year,month(orderdate) as MonthName,count(*) as OrderCount
-- from orders
-- group by Year,month
-- order by OrderCount desc;
SELECT
    EXTRACT(YEAR FROM OrderDate) AS OrderYear,
    OrderDate, 'Month' AS MonthName,
    COUNT(*) AS OrderCount,
    LAG(COUNT(*)) OVER (PARTITION BY OrderDate,
    'Month' ORDER BY EXTRACT(YEAR FROM OrderDate)) AS PreviousYearOrderCount,
    CONCAT(
        CASE
            WHEN COUNT(*) > 0 AND
            LAG(COUNT(*)) OVER (PARTITION BY OrderDate, 'Month' ORDER BY EXTRACT(YEAR FROM OrderDate)) > 0 THEN
                CONCAT(
                    ROUND(((COUNT(*) - LAG(COUNT(*)) OVER (PARTITION BY OrderDate, 
                    'Month' ORDER BY EXTRACT(YEAR FROM OrderDate))) * 100.0) / LAG(COUNT(*)) OVER (PARTITION BY OrderDate,
                    'Month' ORDER BY EXTRACT(YEAR FROM OrderDate))),
                    '%'
                )
            ELSE '0%'
        END
    ) AS YoYPercentageChange
FROM Orders
GROUP BY OrderYear
ORDER BY OrderYear;

-- Day 13
-- 1)Display the customer numbers and customer names from customers table who have not placed any orders using subquery
-- Table: Customers, Orders
select customernumber,customername
from  customers  
where customernumber not in (
select customernumber 
from orders);

-- 2)Write a full outer join between customers and orders using union 
-- and get the customer number, customer name, count of orders for every customer.
-- Table: Customers, Orders

select c.customernumber,c.customername,count(o.customernumber) as order_count
from customers c
left outer join orders o
on c.customernumber = o.customernumber
group by c.customernumber,c.customername
union 
select o.customernumber,c.customername,count(o.customernumber) as order_count
from orders o
right outer join customers c
on c.customernumber = o.customernumber
group by o.customernumber,c.customername;

-- 3)Show the second highest quantity ordered value for each order number.
-- Table: Orderdetails

with orderdetails as (
select ordernumber
,quantityordered
,rank() over (partition by ordernumber order by quantityordered desc) as quantity_rank
from orderdetails )
select ordernumber , max(quantityordered) as secondhighestquantity 
from orderdetails 
where quantity_rank = 2
group by ordernumber ;

-- 4)For each order number count the number of products 
-- and then find the min and max of the values among count of orders.
-- Table: Orderdetails
with orderproductscount as ( 
select ordernumber , count(*) as productcount 
from orderdetails 
group by ordernumber )
select 
max(productcount) as max_total ,
min(productcount) as min_total 
from orderproductscount;

-- 5)Find out how many product lines are there for which the 
-- buy price value is greater than the average of buy price value. 
-- Show the output as product line and its count.

select productline , count(*) as productline_count 
from products
where buyprice > (select avg(buyprice) from products)
group by productline;

-- Day 14
-- Create the table Emp_EH. Below are its fields.
-- ●EmpID (Primary Key)
-- ●EmpName
-- ●EmailAddress
-- Create a procedure to accept the values for the columns in Emp_EH. 
-- Handle the error using exception handling concept. 
-- Show the message as “Error occurred” in case of anything wrong.

create table Emp_EH ( 
EmpID INT primary key ,
EmpName varchar (50) ,
EmailAddress varchar(50) 
);
insert into Emp_EH
values(1,'Lilly','lillydunphy@gmail.com'),
(2,'Phill','phillipescon@gmail.com');
insert into Emp_EH
values (3,'Mandy','madny34@gmail.com'),
(4,'Clarie','clariescot6@gmail.com');

DROP PROCEDURE IF EXISTS Insert_Emp_EH;
delimiter && 
create procedure Insert_Emp_EH ( 
in EmpID INT ,
in EmpName varchar (50) ,
in EmailAddress varchar(50) 
)
begin 
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
SELECT "Error Occured" AS errorMessage;
end ;
select * from Emp_EH
-- insert into Emp_EH 
-- VALUES('marry','mail')
END &&
DELIMITER ;

CALL Insert_Emp_EH;

-- day - 15 
-- Create the table Emp_BIT. Add below fields in it.
-- ●Name
-- ●Occupation
-- ●Working_date
-- ●Working_hours
create table Emp_BIT ( 
Name varchar(50) ,
Occupation varchar(50) , 
Working_date date , 
Working_hours int
) ;
-- Insert the data as shown in below query.
INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);  
-- Create before insert trigger to make sure any new value of Working_hours, 
-- if it is negative, then it should be inserted as positive.
DELIMITER &&
CREATE TRIGGER Before_Insert_Emp_BIT
BEFORE INSERT ON Emp_BIT For Each Row
BEGIN    
  if New.Working_Hours < 0 then 
    set New.Working_Hours = -New.Working_Hours ;
end if ;
end &&
DELIMITER ;
