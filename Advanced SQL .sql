----Advanced SQL Data Analysis ---
CREATE TABLE dbo.OpenSchema	(objectid INT NOT NULL,
							attribute NVARCHAR(30) NOT NULL,
							value SQL_VARIANT NOT NULL,
								CONSTRAINT PK_OpenSchema PRIMARY KEY (objectid, attribute));
GO

INSERT INTO dbo.OpenSchema(objectid, attribute, value) 
VALUES	(1, N'attr1', CAST(CAST('ABC' AS VARCHAR(10)) AS SQL_VARIANT)),
		(1, N'attr2', CAST(CAST(10 AS INT) AS SQL_VARIANT)),
		(1, N'attr3', CAST(CAST('20130101' AS DATE) AS SQL_VARIANT)),
		(2, N'attr2', CAST(CAST(12 AS INT) AS SQL_VARIANT)),
		(2, N'attr3', CAST(CAST('20150101' AS DATE) AS SQL_VARIANT)),
		(2, N'attr4', CAST(CAST('Y' AS CHAR(1)) AS SQL_VARIANT)),
		(2, N'attr5', CAST(CAST(13.7 AS NUMERIC(9,3))AS SQL_VARIANT)),
		(3, N'attr1', CAST(CAST('XYZ' AS VARCHAR(10)) AS SQL_VARIANT)),
		(3, N'attr2', CAST(CAST(20 AS INT) AS SQL_VARIANT)),
		(3, N'attr3', CAST(CAST('20140101' AS DATE) AS SQL_VARIANT));
GO

SELECT objectid, attribute, value 
FROM dbo.OpenSchema;
-- Your task is to write a query that pivots the data into the following form:
--tid	attr1	attr2	attr3						attr4			attr5
------------------------------------------------------------------------------
--1		ABC		10		2013-01-01	00:00:00.000	NULL			NULL
--2		NULL	12		2015-01-01	00:00:00.000	Y				13.700
--3		XYZ		20		2014-01-01	00:00:00.000	NULL			NULL

SELECT	objectid,
		MAX(CASE WHEN attribute = 'attr1' THEN [value] END) AS attr1,
		MAX(CASE WHEN attribute = 'attr2' THEN [value] END) AS attr2,
		MAX(CASE WHEN attribute = 'attr3' THEN [value] END) AS attr3,
		MAX(CASE WHEN attribute = 'attr4' THEN [value] END) AS attr4,
		MAX(CASE WHEN attribute = 'attr5' THEN [value] END) AS attr5
FROM dbo.OpenSchema
GROUP BY objectid;


select objectid,[attr1],[attr2],[attr3],[attr4],[attr5]
from (SELECT objectid, attribute, value 
FROM dbo.OpenSchema) os
pivot (max(value) for attribute in ([attr1],[attr2],[attr3],[attr4],[attr5])) as pvt