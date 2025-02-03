SELECT* FROM dbo.customer_journey
-- STEP 5:COMMON TABLE EXPRESSIONS(CTE) to identify and tag duplicate records
-- Step 5.1: Identifying Duplicate Records
WITH DuplicateRecords AS(
	SELECT JourneyID,
			CustomerID,
			ProductID,
			VisitDate,
			Stage,
			Action,
			Duration,
			ROW_NUMBER() OVER(
				PARTITION BY CustomerID,ProductID,VisitDate,Stage,Action
				ORDER BY JourneyID
			) AS row_num
	FROM dbo.customer_journey)

SELECT *FROM DuplicateRecords
WHERE row_num > 1
ORDER BY JourneyID;

-- Step 5.2: Cleaning and Standardizing Data

SELECT 
	JourneyID,
	CustomerID,
	ProductID,
	VisitDate,
	Stage,
	Action,
	COALESCE(Duration, avg_dur) AS Duration
	FROM(
		SELECT 
			JourneyID,
			CustomerID,
			ProductID,
			VisitDate,
			UPPER(Stage) AS Stage,
			Action,
			Duration,
			AVG(Duration) OVER (PARTITION BY VisitDate) AS avg_dur,
			ROW_NUMBER() OVER(
				PARTITION BY CustomerID,ProductID,VisitDate,UPPER(Stage),Action
				ORDER BY JourneyID
				) AS row_num
	FROM dbo.customer_journey
	) AS subquery
WHERE row_num=1