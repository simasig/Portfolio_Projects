GO

USE master

GO

CREATE DATABASE Sales

GO

USE Sales

GO

CREATE TABLE ShipMethod
(ShipMethodID INT NOT NULL,
Name NVARCHAR(50) ,
ShipBase MONEY NOT NULL,
ShipRate Money NOT NULL,
RowGid UNIQUEIDENTIFIER NOT NULL,
ModifiedDate DATETIME NOT NULL,
CONSTRAINT ship_method_id_pk PRIMARY KEY (ShipMethodID))

GO

CREATE TABLE SalesTerritory
(TerritoryID INT NOT NULL,
Name NVARCHAR(50) NOT NULL,
CountryRegionCode NVARCHAR(3) NOT NULL,
[GROUP] NVARCHAR(50) NOT NULL,
SalesYTD MONEY NOT NULL,
SalesLastYear MONEY NOT NULL,
CostYTD MONEY NOT NULL,
CostLastYear MONEY NOT NULL,
RowGid UNIQUEIDENTIFIER NOT NULL,
ModifiedDate DATETIME NOT NULL,
CONSTRAINT territory_id_pk PRIMARY KEY (TerritoryID))

GO

CREATE TABLE Address
(AddressID INT NOT NULL,
AddressLine1 NVARCHAR(60) NOT NULL,
AddressLine2 NVARCHAR(60),
City NVARCHAR(30) NOT NULL,
StateProvinceID INT NOT NULL,
PostalCode NVARCHAR(15) NOT NULL,
SpatialLocation GEOGRAPHY,
RowGuid UNIQUEIDENTIFIER NOT NULL,
ModifiedDate DATETIME NOT NULL,
CONSTRAINT address_id_pk PRIMARY KEY (AddressID))

GO

CREATE TABLE CreditCard
(CreditCardID INT NOT NULL,
CardType NVARCHAR(50) NOT NULL,
CardNumber NVARCHAR(25) NOT NULL,
ExpMonth TINYINT NOT NULL,
ExpYear SMALLINT NOT NULL,
ModifiedDate DATETIME NOT NULL,
CONSTRAINT cresit_card_id_pk PRIMARY KEY (CreditCardID))

GO

CREATE TABLE CurrencyRate
(CurrencyRateID INT NOT NULL, 
CurrencyRateDate DATETIME NOT NULL,
FromCurrencyCode NCHAR(3) NOT NULL,
ToCurrencyCode NCHAR(3) NOT NULL,
AverageRate MONEY NOT NULL,
EndOfDayRate MONEY NOT NULL,
ModifiedDate DATETIME NOT NULL,
CONSTRAINT currency_rate_id_pk PRIMARY KEY (CurrencyRateID))

GO

CREATE TABLE Customer
(CustomerID INT NOT NULL,
PersonID INT,
StoreID INT,
TerritoryID INT,
AccountNumber VARCHAR(50) NOT NULL,
RowGid UNIQUEIDENTIFIER NOT NULL,
ModifiedDate DATETIME NOT NULL,
CONSTRAINT customer_id_pk PRIMARY KEY (CustomerID),
CONSTRAINT customer_territory_fk FOREIGN KEY(TerritoryID) REFERENCES SalesTerritory(TerritoryID))

GO

CREATE TABLE SalesPerson
(BusinessEntityID INT NOT NULL,
TerritoryID INT,
SalesQuota MONEY,
Bonus MONEY NOT NULL,
CommissionPct SMALLMONEY NOT NULL,
SalesYTD MONEY NOT NULL,
SalesLastYear MONEY NOT NULL,
RowGid UNIQUEIDENTIFIER NOT NULL,
ModifiedDate DATETIME NOT NULL,
CONSTRAINT business_entity_id_pk PRIMARY KEY (BusinessEntityID),
CONSTRAINT person_territory_fk FOREIGN KEY(TerritoryID) REFERENCES SalesTerritory(TerritoryID))

GO

CREATE TABLE SalesOrderHeader
(SalesOrderID INT NOT NULL,
RevisionNumber TINYINT NOT NULL,
OrderDate DATETIME NOT NULL,
DueDate DATETIME NOT NULL,
ShipDate DATETIME,
Status TINYINT NOT NULL,
OnlineOrderFlag BIT,
SalesOrderNumber NVARCHAR(25) NOT NULL,
PurchaseOrderNumber NVARCHAR(25),
AccountNumber NVARCHAR(15),
CustomerID INT NOT NULL,
SalesPersonID INT,
TerritoryID INT,
BillToAddressID INT NOT NULL,
ShipToAddressID INT NOT NULL,
ShipMethodiD INT NOT NULL,
CreditCardID INT,
CreditCardApprovalCode VARCHAR(15),
CurrencyRatedID INT,
SubTotal MONEY NOT NULL,
TaxAmt MONEY NOT NULL,
Freight MONEY NOT NULL,
TotalDue MONEY NOT NULL,
Comment NVARCHAR(150),
RowGuid UNIQUEIDENTIFIER NOT NULL,
ModifiedDate DATETIME NOT NULL,
CONSTRAINT sales_order_id_pk PRIMARY KEY (SalesOrderID),
CONSTRAINT header_ship_fk FOREIGN KEY(ShipMethodiD) REFERENCES ShipMethod(ShipMethodiD),
CONSTRAINT header_currency_fk FOREIGN KEY(CurrencyRatedID) REFERENCES CurrencyRate(CurrencyRateID),
CONSTRAINT header_address_fk FOREIGN KEY(BillToAddressID) REFERENCES Address(AddressID),
CONSTRAINT header_customer_fk FOREIGN KEY(CustomerID) REFERENCES Customer(CustomerID),
CONSTRAINT header_territory_fk FOREIGN KEY(TerritoryID) REFERENCES SalesTerritory(TerritoryID),
CONSTRAINT header_sale_person_fk FOREIGN KEY(SalesPersonID) REFERENCES SalesPerson(BusinessEntityID),
CONSTRAINT header_credit_card_fk FOREIGN KEY(CreditCardID) REFERENCES CreditCard(CreditCardID))

GO

CREATE TABLE SpecialOfferProduct
(SpecialOfferID INT NOT NULL,
 ProductID INT NOT NULL,
 RowGuid UNIQUEIDENTIFIER NOT NULL,
 ModifiedDate DATETIME NOT NULL,
 CONSTRAINT special_offer_product_pk PRIMARY KEY([SpecialOfferID], [ProductID]))

GO

 CREATE TABLE SalesOrderDetail
(SalesOrderID INT NOT NULL,
 SalesOrderDetailID INT NOT NULL,
 CarrierTrackingNumber NVARCHAR(50),
 OrderQty SMALLINT NOT NULL,
 ProductID INT NOT NULL,
 SpecialOfferID INT NOT NULL,
 UnitPrice MONEY NOT NULL,
 UnitPriceDiscount MONEY NOT NULL,
 LineTotal INT NOT NULL,
 RowGuid UNIQUEIDENTIFIER NOT NULL,
 ModifiedDate DATETIME NOT NULL,
 CONSTRAINT sales_order_id_order_detail_pk PRIMARY KEY (SalesOrderID,SalesOrderDetailID),
 CONSTRAINT detail_sales_order_fk FOREIGN KEY(SalesOrderID) REFERENCES SalesOrderHeader(SalesOrderID),
 CONSTRAINT detail_special_offer_fk FOREIGN KEY(SpecialOfferID,ProductID) REFERENCES SpecialOfferProduct(SpecialOfferID,ProductID))

 GO

INSERT INTO Sales..ShipMethod
SELECT*
FROM [AdventureWorks2019].[Purchasing].[ShipMethod]

GO

INSERT INTO Sales..SalesTerritory
SELECT*
FROM [AdventureWorks2019].[Sales].[SalesTerritory]

GO

INSERT INTO Sales..Address
SELECT*
FROM [AdventureWorks2019].[Person].[Address]

GO

INSERT INTO Sales..CreditCard
SELECT*
FROM [AdventureWorks2019].[Sales].[CreditCard]

GO

INSERT INTO Sales..CurrencyRate
SELECT*
FROM [AdventureWorks2019].[Sales].[CurrencyRate]

GO

INSERT INTO Sales..Customer
SELECT*
FROM [AdventureWorks2019].[Sales].[Customer]

GO

INSERT INTO Sales..SalesPerson
SELECT*
FROM [AdventureWorks2019].[Sales].[SalesPerson]

GO

INSERT INTO Sales..SalesOrderHeader
SELECT*
FROM [AdventureWorks2019].[Sales].[SalesOrderHeader]

GO

INSERT INTO Sales..SpecialOfferProduct
SELECT*
FROM [AdventureWorks2019].[Sales].[SpecialOfferProduct]

GO

INSERT INTO Sales..SalesOrderDetail
SELECT*
FROM [AdventureWorks2019].[Sales].[SalesOrderDetail]

GO

 








		
		
		
		
		
		
		

		


		

		
	


		

		 




		 

		 
