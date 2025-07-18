create database KMS_db
---create KMS Order table
Select * from KMS_Order

alter table KMS_Order
alter column Sales decimal (10,2);
alter table KMS_Order
alter column Discount decimal (10,2);
alter table KMS_Order
alter column Profit decimal (10,2);
alter table KMS_Order
alter column UnitPrice decimal (10,2);
alter table KMS_Order
alter column ShippingCost decimal (10,2);
alter table KMS_Order
alter column ProductBaseMargin decimal (10,2);

----create Order Status Table
Select * from Order_Status

-------Join KMS_Order and Order Status Table
select * from KMS_order
select * from Order_Status

select KMS_order.OrderID,
       KMS_order.RowID,
	   KMS_order.CustomerName,
	   KMS_order.CustomerSegment,
	   KMS_order.ProductSub_Category,
	   Order_Status.Status
	   from KMS_order
	   join Order_Status
       on Order_Status.OrderID = KMS_order.OrderID

       
Analysis
1. What Product Category has the highest sales?
-----sql
Select ProductCategory, SUM(Sales) As [Total Sales]
   From KMS_Order
   Group by ProductCategory
   Order by [Total Sales] desc

 ANSWER: The Product Category has the highest sales is Technology

2. What are the Top 3 and Bottom 3 regions in terms of sales?
---sql
select top 3 Region, SUM(Sales) As [Total Sales]
   from KMS_Order
   Group by Region
   Order by [Total Sales] desc

select top 3 Region, SUM(Sales) As [Total Sales]
   from KMS_Order
   Group by Region
   Order by [Total Sales] asc

ANSWER: The Top 3 regions in terms of sales are WEST, ONTARIO, PRARIE
        The Bottom 3 regions in terms of sales are NUNAVUT, NORTHWEST TERRITORIES, YUKON

3. What were the total sales of appliances in Ontario?
-----sql
select ProductSub_Category, sum(Sales) As [Total Sales]
   from KMS_Order
   where Province = 'Ontario'
   Group by ProductSub_Category

ANSWER: The total sales of appliances in Ontario is 202346.84

4. Advise the management of KMS on what to do to increase the revenue from the bottom 10 customers
----sql
select top 10 CustomerName, sum(Sales) as  [Total Sales], sum(Profit) as [Total Profit], sum(ShippingCost) as [Total Shipping Cost], Max(ProductCategory) as Category
   from KMS_Order
   Group by CustomerName
   order by [Total Sales] asc

ANSWER: To increase the revenue from the bottom 10 customers;
         1. Use cheaper shipping option to reduce shipping cost
		 2. Offer free or discounted shipping when order is above a certain amount
		 3. Encourage customers to buy in bulk
		 4. Promote other products to these customer.

5.KMS incurred the most shipping cost using which shipping method?
-----sql
select ShipMode, sum(ShippingCost) as [Total Shipping Cost]
   from KMS_Order
   group by ShipMode
   order by [Total Shipping Cost] desc

ANSWER: The shipping method with the most shipping cost is DELIVERY TRUCK

6.Who are the most valuable customers, and what products or services do they typically purchase?
-----sql
select top 10 CustomerSegment, CustomerName, ProductSub_Category, sum(sales) as[Total Sales]
   from KMS_Order
   group by CustomerSegment, CustomerName, ProductSub_Category
   order by [Total Sales] desc

ANSWER:The most valuable customer are: 
         Emily Phan      
         Raymond Book
         Dennis Kane
         Jasper Cacioppo
         Grant Carroll
         Clytie Kelty
         Craig Carreira
         Roy Skaria
         Roy Phan
         Lisa DeCherney
	  The products do purchase are:
	     Office Machines
         Copiers and Fax
         Copiers and Fax
         Office Machines
         Binders and Binder Accessories
         Copiers and Fax
         Office Machines
         Bookcases
         Office Machines


7. Which small business customer had the highest sales?
---sql
select top 1 CustomerSegment, CustomerName, sum(Sales) as [Total Sales]
   from KMS_Order
   where CustomerSegment = 'Small Business'
   group by CustomerSegment, CustomerName
   order by [Total Sales] desc
   
ANSWER The small business customer with the highest sales is DENNIS KANE

8. Which Corporate Customer placed the most number of orders in 2009 - 2012?
--sql
select top 1 CustomerName, CustomerSegment, count(OrderID) as [Number of Orders]
   from KMS_Order
   where CustomerSegment = 'Corporate'
   And OrderDate Between '2009-01-01' and '2012-12-31'
   group by CustomerName, CustomerSegment
   order by [Number of Orders] desc
   
ANSWER The Corporate customer with the  most number of orders in 2009 - 2012 is ADAM HART

9. Which consumer customer was the most profitable one?
--sql
select top 1 CustomerName, CustomerSegment, sum(Profit) as [Total Profit]
   from KMS_Order
   where CustomerSegment = 'Consumer'
   group by CustomerName, CustomerSegment
   order by [Total Profit] desc

ANSWER  The consumer customer that was the most profitable is EMILY PHAN 

10. Which customer returned items, and what segment do they belong to?
--sql
select * from (
    select OrderID, RowID, CustomerName, CustomerSegment, ProductSub_Category from KMS_Order) as Customer
join(
    select OrderID, Status from Order_Status) as Returned
	on Customer.OrderID = Returned.OrderID
  
  ANSWER 872 Customer returned items

  11. If the delivery truck is the most economical but the slowest shipping method and Express Air is the fastest but the most expensive one, 
  do you think the company appropriately spent shipping costs based on the Order Priority? Explain your answer
  ---sql
select ShipMode, OrderPriority, ShippingCost as ShippingCost
       from KMS_Order
	   where ShipMode in ('Express Air', 'Delivery Truck')
	   order by ShippingCost
	  
Answer
	No, the company does not appropriately spend shipping costs based on Order Priority.
	Regardless of order priority, whether Critical, High, Medium, or Low  the cost remains the same.
	Express Air is the fastest shipping method, yet its shipping cost per order is low than Delivery Truck Which is the slowest method
	This shows a clear misalignment between the Order Priority and the Shipping Method used. 
	The company could have spent less and delivered faster by using Express Air more strategically for high-priority orders.