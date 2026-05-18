Create database Adv;
use Adv;
create table final_fact as  Select * from  fact_internet_sales_new union all  select * from factinternetsales;

Alter Table DimDate Change Column `ï»¿DateKey` DateKey Int;
Alter Table DimCustomer Change Column `ï»¿CustomerKey` CustomerKey Int;
Alter Table DimProduct Change Column `ï»¿ProductKey` ProductKey Int;
Alter Table DimProductCategory Change Column `ï»¿ProductCategoryKey` ProductCategoryKey Int;
Alter Table DimProductSubcategory Change Column `ï»¿ProductSubcategoryKey` ProductSubcategoryKey Int;
Alter Table DimSalesTerritory Change Column `ï»¿SalesTerritoryKey` SalesTerritory Int;
Alter Table final_fact Change Column `ï»¿ProductKey` ProductKey Int;

##Removing Unncessary Columns
 
Alter Table DimCustomer Drop Column Title, Drop Column MiddleName,Drop Column NameStyle,Drop Column Suffix,
Drop Column EmailAddress,Drop Column SpanishEducation,Drop Column FrenchEducation,Drop Column SpanishOccupation,
Drop Column FrenchOccupation,Drop Column AddressLine2,Drop Column Phone;

Alter Table DimCustomer Add Column Birth_Date date;
Update DimCustomer Set Birth_Date = date_add('1899-12-30', Interval BirthDate Day);
Alter Table DimCustomer Drop Column BirthDate;

Alter Table DimCustomer Add Column DateFirst_Purchase date;
Update DimCustomer Set DateFirst_Purchase= date_add('1899-12-30', Interval DateFirstPurchase Day);
Alter Table DimCustomer Drop Column DateFirstPurchase;

Alter Table DimDate Drop Column SpanishDayNameOfWeek,Drop Column FrenchDayNameOFWeek,
Drop Column DayNumberOfMonth,Drop Column WeekNumberOfYear,Drop Column SpanishMonthName,
Drop Column FrenchMonthName,Drop Column CalendarSemester,Drop Column FiscalSemester;

Alter Table DimProductCategory 
Drop Column ProductCategoryAlternateKey,Drop Column SpanishProductCategoryName,Drop Column FrenchProductCategoryName;

Alter Table DimProductSubCategory 
Drop Column ProductSubCategoryAlternateKey,Drop Column SpanishProductSubCategoryName,Drop Column FrenchProductSubCategoryName;

Alter Table DimSalesTerritory
Drop Column SalesTerritoryALternateKey;

Alter Table final_fact
Drop Column DueDateKey,Drop Column ShipDateKey,Drop Column PromotionKey,Drop Column CurrencyKey,Drop Column RevisionNumber,
Drop Column UnitPrice,Drop Column ExtendedAmount,Drop Column UnitPriceDiscountPct,Drop Column DiscountAmount,
Drop Column ProductStandardCost,Drop Column CarrierTrackingNumber,Drop Column CustomerPONumber,Drop Column OrderDate,
Drop Column DueDate,Drop Column ShipDate;

##Creating Realtion Between Tables
Alter Table DimCustomer Add primary key (CustomerKey); 
Alter Table DimDate Add primary key (DateKey);
Alter Table DimProduct Add primary key (ProductKey);
Alter Table DimSalesTerritory Add primary key (SalesTerritory);

Alter Table final_fact add constraint fk_customer foreign key (CustomerKey) references DimCustomer (CustomerKey);
Alter Table final_fact add constraint fk_product foreign key (ProductKey) references DimProduct (ProductKey);
Alter Table final_fact add constraint fk_date foreign key (OrderDateKey) references DimDate (DateKey);
Alter Table final_fact add constraint fk_territory foreign key (SalesTerritoryKey) 
references DimSalesTerritory (SalesTerritory);

##Calculation Of Date Field

Alter Table final_fact Add column OrderDate date;
Update final_fact  set OrderDate = str_to_date(OrderDateKey, '%Y%m%d');

##Year 
Alter Table final_fact Add Column Year int;
update final_fact set Year = Year(OrderDate);

##MonthName
Alter Table final_fact Add Column Monthname varchar(20);
update final_fact set Monthname = monthname(OrderDate);

##MonthNo
Alter Table final_fact Add Column MonthNo int;
update final_fact set MonthNo = month(OrderDate);

##Quarter
Alter Table final_fact Add Column Quarter varchar(5);
update final_fact set Quarter = concat('Q' , quarter(OrderDate));

##YearMonth
Alter Table final_fact Add Column YearMonth varchar(10);
update final_fact set YearMonth = date_format(OrderDate, '%Y-%b');

##WeekDayNo
Alter Table final_fact Add Column WeekDayNo int;
update final_fact set WeekDayNo = weekday(OrderDate) + 1;

##WeekDayName
Alter Table final_fact Add Column WeekDayName varchar(20);
update final_fact set WeekDayName = dayname(OrderDate);

##Profit
Alter Table final_fact Add Column Profit decimal(10,2);
Update final_fact set Profit = SalesAmount - TotalProductCost ;

##KPI Calculation

##1.Total Sales
Select round(sum(SalesAmount),2) as Total_Sales from final_fact;

##2.Total ProductCost
Select round(sum(TotalProductCost),2) as Total_Product_Cost from final_fact;

##3.Total Profit
Select round(sum(Profit),2) as Total_Profit from final_fact;

##4. Total Orders 
select count(orderquantity) as Total_Orders from final_fact;

##5.Maximum Sales
Select max(SalesAmount) as Maximum_Sales from final_fact;
