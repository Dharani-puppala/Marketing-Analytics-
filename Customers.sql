SELECT * FROM dbo.customers
SELECT * FROM dbo.geography
-- join customers with geography to enrich customers data with geographic information
-- left join on customers, geography using GeographyID
SELECT C.CustomerName, C.CustomerID,C.Email,C.Gender,C.Age ,
G.City,G.Country

FROM
dbo.customers AS C LEFT JOIN dbo.geography AS G
ON C.GeographyID=G.GeographyID

--SELECT C.CustomerID,C.CustomerName,G.City,G.Country FROM
--dbo.customers AS C
--RIGHT JOIN dbo.geography AS G
--ON C.GeographyID=G.GeographyID

--SELECT * FROM 
--dbo.customers AS C INNER JOIN dbo.geography AS G
--ON  C.GeographyID=G.GeographyID

-- STEP 3  : Query to clean whitespace issuses in the Review Text column
SELECT * FROM dbo.customer_reviews

SELECT ReviewID,CustomerID,ProductID,ReviewDate,Rating,
REPLACE(ReviewText,' ','') AS Review
FROM dbo.customer_reviews
--ORDER BY Rating DESC

--STEP 4: Query to clean and normalize the engagement data
SELECT EngagementID,
ContentID,
CampaignID,
ProductID,
UPPER(REPLACE(ContentType,'Socialmedia','Social Media'))AS ContentType,
LEFT(ViewsClicksCombined,CHARINDEX('-',ViewsClicksCombined)-1) AS Viwes,
RIGHT(ViewsClicksCombined,LEN(ViewsClicksCombined)-CHARINDEX('-',ViewsClicksCombined)) AS Clicks,
Likes,
FORMAT(CONVERT(DATE,EngagementDate),'MM.dd.yyyy') AS EngagementDate
FROM dbo.engagement_data
WHERE ContentType !='newsletters';
