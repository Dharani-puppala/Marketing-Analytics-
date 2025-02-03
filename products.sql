SELECT * FROM dbo.products
-- Query to categorize procuts based o ther price
SELECT ProductID, ProductName, Price,
CASE
	WHEN Price < 50 THEN 'LOW'
	WHEN Price BETWEEN 50 AND 200 THEN 'MEDIUM'
	ELSE 'HIGH'
END AS PriceCategory
FROM dbo.products