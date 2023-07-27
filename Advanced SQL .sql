---Project 2 - SQL Data Analysis ---Solutions 


---1
SELECT  p.ProductID,p.Name,p.Color,p.ListPrice,p.Size     
FROM  Sales.SalesOrderDetail  S RIGHT OUTER JOIN
     Production.Product P 
ON S.ProductID = P.ProductID
WHERE S.SalesOrderID IS NULL

 --2

 

 SELECT C.CustomerID
 ,case when c.PersonID IS NULL THEN 'unknown'
		  ELSE p.LastName
	END lastName
 ,case when c.PersonID IS NULL THEN 'unknown'
		  ELSE p.FirstName
	END FirstName
 FROM Person.Person p RIGHT join sales.Customer c
  ON p.BusinessEntityID=c.PersonID
  LEFT JOIN sales.SalesOrderHeader s
 ON s.CustomerID = c.CustomerID
  WHERE s.SalesOrderID IS NULL
ORDER BY C.CustomerID
  
 ---3

 SELECT  TOP 10 C.CustomerID, p.FirstName,  p.LastName,COUNT(*) AS CountOfOrders
FROM Person.Person AS P
INNER JOIN Sales.Customer AS C 
	ON P.BusinessEntityID = C.PersonID
INNER JOIN Sales.SalesOrderHeader AS SOH 
	ON C.CustomerID = SOH.CustomerID
GROUP BY C.CustomerID, p.FirstName,  p.LastName
ORDER BY CountOfOrders DESC;


--4

WITH J
AS 
	(SELECT COUNT(*) AS CountOfTitle, JobTitle
	FROM HumanResources.Employee
	GROUP BY JobTitle)
SELECT FirstName, LastName, e.JobTitle, HireDate, CountOfTitle
FROM HumanResources.Employee  e
INNER JOIN Person.Person AS p ON e.BusinessEntityID = p.BusinessEntityID
INNER JOIN J ON e.JobTitle = j.JobTitle;


--5
WITH cte
AS
(
SELECT s.SalesOrderID,c.CustomerID,c.PersonID, p.LastName,p.FirstName,s.OrderDate LastOrder
,lag(orderdate,1)OVER(PARTITION By c.personid ORDER BY orderdate ) PreviousOrder

FROM sales.SalesOrderHeader s JOIN Sales.Customer C
ON s.CustomerID =c.CustomerID
join Person.Person p
ON p.BusinessEntityID=c.PersonID
)
SELECT SalesOrderID,CustomerID,LastName , FirstName ,LastOrder,PreviousOrder
FROM cte c
WHERE LastOrder in (SELECT MAX(LastOrder)
					FROM cte i
					WHERE  c.CustomerID=i.CustomerID
					)


--6

WITH a
AS
(	SELECT   s.SalesOrderID,sh.customerid,SUM(s.UnitPrice*s.OrderQty*(1-s.UnitPriceDiscount)) Total
	,YEAR(sh.orderdate) "Year"
	FROM sales.SalesOrderDetail s JOIN sales.SalesOrderHeader sh
	ON  s.SalesOrderID = sh.SalesOrderID
	GROUP BY s.SalesOrderID,YEAR(sh.orderdate),sh.customerid),
b AS (
	SELECT *, DENSE_RANK() OVER(PARTITION BY year  ORDER BY TOTAL DESC) AS MAX_TOTAL
	FROM a
)
SELECT b.Year,b.SalesOrderID,p.LastName,p.FirstName,FORMAT(b.Total,'#,#.0') AS Total
FROM b JOIN sales.customer c
ON b.customerid = c.customerid
JOIN person.person p
ON c.personid = p.BusinessEntityID
WHERE max_total=1


--7
go
SELECT [Month],[2011],[2012],[2013],[2014]
FROM (
SELECT sh.SalesOrderID,YEAR(sh.orderdate) AS "Year" ,MONTH(sh.orderdate) AS "Month"
FROM sales.salesorderheader sh ) S
PIVOT(COUNT (SALESORDERID) FOR [Year] IN ([2011],[2012],[2013],[2014]))  PVT
ORDER BY [Month]


--8
WITH cte
AS(
	SELECT YEAR(sh.orderdate) AS [Year] ,MONTH(sh.orderdate) AS [Month]
	,CAST(ROUND(SUM(s.unitprice*(1-s.UnitPriceDiscount)),2) AS MONEY) Sum_Price

	FROM sales.SalesOrderDetail s join sales.SalesOrderHeader sh
	ON  s.SalesOrderID = sh.SalesOrderID
	GROUP BY  YEAR(sh.orderdate)  ,MONTH(sh.orderdate))
SELECT [Year],CAST([Month] AS VARCHAR) AS [Month],Sum_Price ,SUM(Sum_Price)OVER(PARTITION BY [Year] ORDER BY [Month]
						ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS CumSum
FROM Cte
WHERE [Year]=2011
UNION 
SELECT 2011,'grand_total',NULL,SUM(Sum_Price)
FROM Cte
 WHERE [Year]=2011
UNION
SELECT [Year],CAST([Month] AS VARCHAR) AS MONTH,Sum_Price ,SUM(Sum_Price)OVER(PARTITION BY [Year] ORDER BY [Month]
						ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Money
FROM Cte
WHERE[Year]=2012
UNION 
SELECT 2012,'grand_total',null,SUM(Sum_Price)
FROM Cte
 WHERE [Year]=2012
UNION
SELECT [Year],CAST([Month] AS VARCHAR) AS MONTH,Sum_Price ,SUM(Sum_Price)OVER(PARTITION BY [Year] ORDER BY [Month]
						ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS MONEY
FROM Cte
WHERE [Year]=2013
UNION 
SELECT 2013,'grand_total',null,SUM(Sum_Price)
FROM Cte
 WHERE [Year]=2013
UNION
SELECT [Year],CAST([Month] AS VARCHAR) AS MONTH,Sum_Price ,SUM(Sum_Price)OVER(PARTITION BY [Year] ORDER BY [Month]
						ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS MONEY
FROM Cte
WHERE[Year]=2014
UNION
SELECT 2014,'grand_total' ,null ,SUM(Sum_Price)
FROM Cte
 WHERE [Year]=2014
 ORDER BY 1,4

 

 ---9

SELECT *
FROM(
	SELECT 
		D.Name AS "DepartmentName"
		,E.BusinessEntityID AS "Employee'sId"
		,CONCAT(P.FirstName,' ',P.LastName)AS "Employee'sFullName"
		,E.HireDate
		,DATEDIFF(MM,E.HireDate,GETDATE()) AS "Seniority"
		,LEAD(CONCAT(P.FirstName,' ',P.LastName),1)OVER(PARTITION BY D.Name ORDER BY E.HireDate desc) PreviuseEmpName
		,LEAD(e.hiredate,1)OVER(PARTITION BY D.Name ORDER BY E.HireDate desc) AS PreviusEmpHDate
		,DATEDIFF(DD,LEAD(e.hiredate,1)OVER(PARTITION BY D.Name ORDER BY E.HireDate desc),E.HireDate) DiffDays
	FROM HumanResources.Employee E JOIN HumanResources.EmployeeDepartmentHistory EDH
	ON E.BusinessEntityID=EDH.BusinessEntityID
	JOIN HumanResources.Department D
	ON D.DepartmentID=EDH.DepartmentID
	JOIN Person.Person P
	ON P.BusinessEntityID=E.BusinessEntityID
	)E

	--10


go

	with hd as
(select distinct hiredate,departmentid from 
 HumanResources.Employee E 
JOIN HumanResources.EmployeeDepartmentHistory EDH
ON E.BusinessEntityID=EDH.BusinessEntityID
where edh.enddate is null) 
select hd.hiredate,hd.departmentid,
STUFF(( select ',' + concat(E.BusinessEntityID,' ',P.LastName,' ' ,P.FirstName,' ')
        FROM HumanResources.Employee E JOIN HumanResources.EmployeeDepartmentHistory EDH
            ON E.BusinessEntityID=EDH.BusinessEntityID
	     JOIN Person.Person P
         ON P.BusinessEntityID=E.BusinessEntityID
		 where e.hiredate=hd.hiredate and edh.departmentid=hd.departmentid
		 for XML path('')),1,1,'') TeamEmployees
		 from hd
ORDER BY hd.HireDate DESC

go
SELECT Emp.HireDate,EmpDepHis.DepartmentID,
STRING_AGG(Concat(Emp.BusinessEntityID,' ',Per.LastName,' ',Per.FirstName),' ,')
WITHIN GROUP (ORDER BY Emp.BusinessEntityID) AS TeamEmployees
FROM [HumanResources].[Employee] AS Emp 
JOIN [HumanResources].[EmployeeDepartmentHistory] AS EmpDepHis
ON Emp.BusinessEntityID=EmpDepHis.BusinessEntityID
JOIN [Person].[Person] AS Per 
ON Emp.BusinessEntityID=Per.BusinessEntityID
WHERE EmpDepHis.EndDate IS NULL
GROUP BY Emp.HireDate,EmpDepHis.DepartmentID
ORDER BY HireDate DESC
