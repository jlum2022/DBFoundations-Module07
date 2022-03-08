--*************************************************************************--
-- Title: Assignment07
-- Author: Jocelyn Lum
-- Desc: This file demonstrates how to use Functions
-- Change Log: When,Who,What
-- 2022-03-01,JLum,Initial version to create database
-- 2022-03-08,JLum,Completed Q1-Q8
--**************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment07DB_JLum')
	 Begin 
	  Alter Database [Assignment07DB_JLum] set Single_user With Rollback Immediate;
	  Drop Database Assignment07DB_JLum;
	 End
	Create Database Assignment07DB_JLum;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment07DB_JLum;

-- Create Tables (Module 01)-- 
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [money] NOT NULL
);
go

Create Table Employees -- New Table
([EmployeeID] [int] IDENTITY(1,1) NOT NULL 
,[EmployeeFirstName] [nvarchar](100) NOT NULL
,[EmployeeLastName] [nvarchar](100) NOT NULL 
,[ManagerID] [int] NULL  
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[EmployeeID] [int] NOT NULL
,[ProductID] [int] NOT NULL
,[ReorderLevel] int NOT NULL -- New Column 
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Begin  -- Categories
	Alter Table Categories 
	 Add Constraint pkCategories 
	  Primary Key (CategoryId);

	Alter Table Categories 
	 Add Constraint ukCategories 
	  Unique (CategoryName);
End
go 

Begin -- Products
	Alter Table Products 
	 Add Constraint pkProducts 
	  Primary Key (ProductId);

	Alter Table Products 
	 Add Constraint ukProducts 
	  Unique (ProductName);

	Alter Table Products 
	 Add Constraint fkProductsToCategories 
	  Foreign Key (CategoryId) References Categories(CategoryId);

	Alter Table Products 
	 Add Constraint ckProductUnitPriceZeroOrHigher 
	  Check (UnitPrice >= 0);
End
go

Begin -- Employees
	Alter Table Employees
	 Add Constraint pkEmployees 
	  Primary Key (EmployeeId);

	Alter Table Employees 
	 Add Constraint fkEmployeesToEmployeesManager 
	  Foreign Key (ManagerId) References Employees(EmployeeId);
End
go

Begin -- Inventories
	Alter Table Inventories 
	 Add Constraint pkInventories 
	  Primary Key (InventoryId);

	Alter Table Inventories
	 Add Constraint dfInventoryDate
	  Default GetDate() For InventoryDate;

	Alter Table Inventories
	 Add Constraint fkInventoriesToProducts
	  Foreign Key (ProductId) References Products(ProductId);

	Alter Table Inventories 
	 Add Constraint ckInventoryCountZeroOrHigher 
	  Check ([Count] >= 0);

	Alter Table Inventories
	 Add Constraint fkInventoriesToEmployees
	  Foreign Key (EmployeeId) References Employees(EmployeeId);
End 
go

-- Adding Data (Module 04) -- 
Insert Into Categories 
(CategoryName)
Select CategoryName 
 From Northwind.dbo.Categories
 Order By CategoryID;
go

Insert Into Products
(ProductName, CategoryID, UnitPrice)
Select ProductName,CategoryID, UnitPrice 
 From Northwind.dbo.Products
  Order By ProductID;
go

Insert Into Employees
(EmployeeFirstName, EmployeeLastName, ManagerID)
Select E.FirstName, E.LastName, IsNull(E.ReportsTo, E.EmployeeID) 
 From Northwind.dbo.Employees as E
  Order By E.EmployeeID;
go

Insert Into Inventories
(InventoryDate, EmployeeID, ProductID, [Count], [ReorderLevel]) -- New column added this week
Select '20170101' as InventoryDate, 5 as EmployeeID, ProductID, UnitsInStock, ReorderLevel
From Northwind.dbo.Products
UNIOn
Select '20170201' as InventoryDate, 7 as EmployeeID, ProductID, UnitsInStock + 10, ReorderLevel -- Using this is to create a made up value
From Northwind.dbo.Products
UNIOn
Select '20170301' as InventoryDate, 9 as EmployeeID, ProductID, abs(UnitsInStock - 10), ReorderLevel -- Using this is to create a made up value
From Northwind.dbo.Products
Order By 1, 2
go

-- Adding Views (Module 06) -- 
Create View vCategories With SchemaBinding
 AS
  Select CategoryID, CategoryName From dbo.Categories;
go
Create View vProducts With SchemaBinding
 AS
  Select ProductID, ProductName, CategoryID, UnitPrice From dbo.Products;
go
Create View vEmployees With SchemaBinding
 AS
  Select EmployeeID, EmployeeFirstName, EmployeeLastName, ManagerID From dbo.Employees;
go
Create View vInventories With SchemaBinding 
 AS
  Select InventoryID, InventoryDate, EmployeeID, ProductID, ReorderLevel, [Count] From dbo.Inventories;
go

-- Show the Current data in the Categories, Products, and Inventories Tables
Select * From vCategories;
go
Select * From vProducts;
go
Select * From vEmployees;
go
Select * From vInventories;
go

/********************************* Questions and Answers *********************************/
Print
'NOTES------------------------------------------------------------------------------------ 
 1) You must use the BASIC views for each table.
 2) Remember that Inventory Counts are Randomly Generated. So, your counts may not match mine
 3) To make sure the Dates are sorted correctly, you can use Functions in the Order By clause!
------------------------------------------------------------------------------------------'
-- Question 1 (5% of pts):
-- Show a list of Product names and the price of each product.
-- Use a function to format the price as US dollars.
-- Order the result by the product name.

-- Step 1a) Format the price and show next to unformatted price.
--select 
--ProductName
--, UnitPrice
--, format(UnitPrice, 'C', 'en-US') AS 'Price in US Dollars'  
--from vProducts

-- Step 1b) Final answer after adding ORDER BY clause.
select 
ProductName
, FORMAT(UnitPrice, 'C', 'en-US')
from vProducts
order by ProductName;
go

-- Question 2 (10% of pts): 
-- Show a list of Category and Product names, and the price of each product.
-- Use a function to format the price as US dollars.
-- Order the result by the Category and Product.

-- Step 2a) Start with SELECT statement from Assignment 6 Q3
--select
--c.CategoryName
--,p.ProductName
--,p.UnitPrice
--from vProducts p
--	INNER JOIN vCategories c ON p.CategoryID = c.CategoryID
--order by c.CategoryName, p.ProductName, p.UnitPrice

-- Step 2b) Final answer after formatting price.
select
c.CategoryName
,p.ProductName
, FORMAT(p.UnitPrice, 'C', 'en-US')
from vProducts p
	INNER JOIN vCategories c ON p.CategoryID = c.CategoryID
order by c.CategoryName, p.ProductName, p.UnitPrice
go

-- Question 3 (10% of pts): 
-- Use functions to show a list of Product names, each Inventory Date, and the Inventory Count.
-- Format the date like 'January, 2017'.
-- Order the results by the Product and Date.

--Step 3a) Start with SELECT statement from Assignment 6 Q4
--select
--p.ProductName
--,i.InventoryDate
--,i.[Count]
--from vProducts p
--	INNER JOIN vInventories i ON p.ProductID = i.ProductID
--order by p.ProductName, i.InventoryDate, i.[Count]

-- copied from Module 7 Notes
--Declare @Date as DateTime = GetDate();
--Select 
-- [Isdate()] = Isdate(@Date)
--,[Datename()] = DateName(mm,@Date) + ', ' + DateName(Weekday,@Date)  
--,[Datepart()] = str(DatePart(mm, @Date)) + ', ' + str(DatePart(Weekday,@Date)) 
--,[Dateadd()] = DateAdd(mm, 1, @Date)
--,[Datediff()] = DateDiff(yy, '20000101', @Date)
--,[Day()Month()Year()] = str(Day(@Date)) + ', ' + str(Month(@Date)) + ', ' + str(Year(@Date));


-- Step 3b) Extract month and year from Inventory Date
--select
--p.ProductName
--,i.InventoryDate
--,DATENAME(mm,i.InventoryDate) as 'Month'
--,DATENAME(yy, i.InventoryDate)  as 'Year'
--,STR(DATEPART(year, i.InventoryDate)) as 'YearAsText'
--,i.[Count]
--from vProducts p
--	INNER JOIN vInventories i ON p.ProductID = i.ProductID
--order by p.ProductName, i.InventoryDate, i.[Count]

--Step 3c) Final answer after concatenating month & year
select
p.ProductName
,DATENAME(mm,i.InventoryDate) + ', ' + DATENAME(yy, i.InventoryDate) 
	as 'InventoryDate'
,i.[Count]
from vProducts p
	INNER JOIN vInventories i ON p.ProductID = i.ProductID
order by p.ProductName, i.InventoryDate, i.[Count]
go

-- Question 4 (10% of pts): 
-- CREATE A VIEW called vProductInventories. 
-- Shows a list of Product names, each Inventory Date, and the Inventory Count. 
-- Format the date like 'January, 2017'.
-- Order the results by the Product and Date.

-- Step 4a) Create a view based on SELECT statement for Q3 above. This is
--			very similar to Assignment 6 Q4 with a formatted date.
--			Final answer below.
go
create view vProductInventories
as
	select TOP 100000
	p.ProductName
	,DATENAME(mm,i.InventoryDate) + ', ' + DATENAME(yy, i.InventoryDate) 
		as 'InventoryDate'
	,i.[Count] as 'InventoryCount'
	from vProducts p
		INNER JOIN vInventories i ON p.ProductID = i.ProductID
	order by p.ProductName, i.InventoryDate, i.[Count]
go

-- Step 4b) Check that it works: 
--select * from vProductInventories;
--go

-- Question 5 (10% of pts): 
-- CREATE A VIEW called vCategoryInventories. 
-- Shows a list of Category names, Inventory Dates, and a TOTAL Inventory Count BY CATEGORY
-- Format the date like 'January, 2017'.
-- Order the results by the Product and Date.

-- Step 5a) Start with SELECT from Assignment 6 Q6.
--select top 100000
--c.CategoryName
--,p.ProductName
--,i.InventoryDate
--,i.[Count]
--from vProducts p
--	INNER JOIN vInventories i ON p.ProductID = i.ProductID
--	INNER JOIN vCategories c ON p.CategoryID = c.CategoryID
--order by c.CategoryName, p.ProductName, i.InventoryDate, i.[Count]

-- Step 5b) Add GROUP BY clause and use SUM to get total inventory count
--			Format date, remove ProductName column, fix ORDER BY
--select top 100000
--c.CategoryName
--,DATENAME(mm,i.InventoryDate) + ', ' + DATENAME(yy, i.InventoryDate) 
--	as 'InventoryDate'
--,SUM(i.[Count])
--from vProducts p
--	INNER JOIN vInventories i ON p.ProductID = i.ProductID
--	INNER JOIN vCategories c ON p.CategoryID = c.CategoryID
--group by c.CategoryName, i.InventoryDate
--order by c.CategoryName, i.InventoryDate

-- Step 5c) Final answer after adding CREATE VIEW
go
create view vCategoryInventories
as
	select top 100000
	c.CategoryName
	,DATENAME(mm,i.InventoryDate) + ', ' + DATENAME(yy, i.InventoryDate) 
		as 'InventoryDate'
	,SUM(i.[Count]) as 'TotalCount'
	from vProducts p
		INNER JOIN vInventories i ON p.ProductID = i.ProductID
		INNER JOIN vCategories c ON p.CategoryID = c.CategoryID
	group by c.CategoryName, i.InventoryDate
	order by c.CategoryName, i.InventoryDate
go
-- Check that it works:  select * from vCategoryInventories;
--go

-- Question 6 (10% of pts): 
-- CREATE ANOTHER VIEW called vProductInventoriesWithPreviouMonthCounts. 
-- Show a list of Product names, Inventory Dates, Inventory Count, AND the Previous Month Count.
-- Use functions to set any January NULL counts to zero. 
-- Order the results by the Product and Date. 
-- This new view must use your vProductInventories view.

-- Step 6a) Review data in vProductInventories.
--			InventoryDate is not a DATE or DATETIME value, it is a string concatenation 
--			of month name + year. If you order by InventoryDate it sorts alphabetically, 
--			so ORDER BY extracts the year and month in order to sort by date.
--select
--ProductName
--,InventoryDate
--,InventoryCount
--from vProductInventories
--order by ProductName, YEAR(InventoryDate), MONTH(InventoryDate), InventoryCount

-- Step 6b) Use LAG to get count for previous month
--select
--ProductName
--,InventoryDate
--,InventoryCount
--,case 
--	when MONTH(InventoryDate) = 1 then 0		-- If January then set count to 0
--	else ISNULL(LAG((InventoryCount)) 
--		over(order by ProductName, YEAR(Inve  ntoryDate), MONTH(InventoryDate)), 0)
--	end as 'PreviousMonthCount'
----Get previous month count using IIF() for comparison
--,[PreviousMonthCount2] = IIF(InventoryDate Like ('January%'), 0, IsNull(Lag(InventoryCount) Over (Order By ProductName, Year(InventoryDate), Month(InventoryDate)), 0) )
--from vProductInventories
--order by ProductName, YEAR(InventoryDate), MONTH(InventoryDate), InventoryCount

-- Step 6c) 	Final answer below after adding CREATE VIEW
go
create view vProductInventoriesWithPreviousMonthCounts
as
	select top 100000
	ProductName
	,InventoryDate
	,InventoryCount
	,case 
		when MONTH(InventoryDate) = 1 then 0		-- If January then set count to 0
		else ISNULL(LAG((InventoryCount)) 
			over(order by ProductName, YEAR(InventoryDate), MONTH(InventoryDate)), 0)
		end as 'PreviousMonthCount'
	from vProductInventories
	order by ProductName, YEAR(InventoryDate), MONTH(InventoryDate), InventoryCount
go

-- Check that it works: 
--select * from vProductInventoriesWithPreviousMonthCounts;
--go

-- Question 7 (15% of pts): 
-- CREATE a VIEW called vProductInventoriesWithPreviousMonthCountsWithKPIs.
-- Show columns for the Product names, Inventory Dates, Inventory Count, Previous Month Count. 
-- The Previous Month Count is a KPI. The result can show only KPIs with a value of either 1, 0, or -1. 
-- Display months with increased counts as 1, same counts as 0, and decreased counts as -1. 
-- Varify that the results are ordered by the Product and Date.

-- Step 7a) Select all columns from vProductInventoriesWithPreviousMonthCounts
--			Add KPI column
--select top 100000
--ProductName
--,InventoryDate
--,InventoryCount
--,PreviousMonthCount
--,case
--	when InventoryCount > PreviousMonthCount then 1
--	when InventoryCount = PreviousMonthCount then 0
--	when InventoryCount < PreviousMonthCount then -1
--end as 'InventoryKPI'
--from vProductInventoriesWithPreviousMonthCounts
--order by ProductName, YEAR(InventoryDate), MONTH(InventoryDate), InventoryCount

-- Step 7b) Final answer after adding CREATE VIEW
go
create view vProductInventoriesWithPreviousMonthCountsWithKPIs
as
	select top 100000
	ProductName
	,InventoryDate
	,InventoryCount
	,PreviousMonthCount
	,case
		when InventoryCount > PreviousMonthCount then 1
		when InventoryCount = PreviousMonthCount then 0
		when InventoryCount < PreviousMonthCount then -1
	end as 'InventoryKPI'
	from vProductInventoriesWithPreviousMonthCounts
	order by ProductName, YEAR(InventoryDate), MONTH(InventoryDate), InventoryCount
go

-- Important: This new view must use your vProductInventoriesWithPreviousMonthCounts view!
-- Check that it works: select * from vProductInventoriesWithPreviousMonthCountsWithKPIs;
--go

-- Question 8 (25% of pts): 
-- CREATE a User Defined Function (UDF) called fProductInventoriesWithPreviousMonthCountsWithKPIs.
-- Show columns for the Product names, Inventory Dates, Inventory Count, the Previous Month Count. 
-- The Previous Month Count is a KPI. The result can show only KPIs with a value of either 1, 0, or -1. 
-- Display months with increased counts as 1, same counts as 0, and decreased counts as -1. 
-- The function must use the ProductInventoriesWithPreviousMonthCountsWithKPIs view.
-- Varify that the results are ordered by the Product and Date.

-- Step 8a) List out all the columns from vProductInventoriesWithPreviousMonthCountsWithKPIs
--select
--ProductName
--,InventoryDate
--,InventoryCount
--,PreviousMonthCount
--,InventoryKPI
--from vProductInventoriesWithPreviousMonthCountsWithKPIs

-- Step 8b) Filter for a single KPI declared as a variable
--DECLARE @KPILevel as int = 1 -- set to 1, 0, or -1
--select
--ProductName
--,InventoryDate
--,InventoryCount
--,PreviousMonthCount
--,InventoryKPI
--from vProductInventoriesWithPreviousMonthCountsWithKPIs
--where InventoryKPI = @KPILevel

-- Step 8c) Final answer afer making it into a function
create function fProductInventoriesWithPreviousMonthCountsWithKPIs (@KPILevel int)
returns table
as
	return select
		ProductName
		,InventoryDate
		,InventoryCount
		,PreviousMonthCount
		,InventoryKPI
		from vProductInventoriesWithPreviousMonthCountsWithKPIs
		where InventoryKPI = @KPILevel
go

/* Check that it works:
Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(1);
Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(0);
Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(-1);
*/
go

/***************************************************************************************/