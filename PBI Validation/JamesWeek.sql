-- DimWeek

DECLARE @DatasetRefresh datetime = GetDate();

WITH CTE_DATES AS 
(
SELECT 
	 [Fiscal Week]
	,[Fiscal Week PY]
	,[Fiscal Week PY Q4 Leap Year] = 
		CASE WHEN MAX(RIGHT([Fiscal Week],2)) OVER (PARTITION BY [Fiscal Year]) = 53  THEN 
			 CONVERT(varchar(max),CONVERT(int,[Fiscal Week PY]) -1)
		 ELSE 
			REPLACE([Fiscal Week PY],'-','') 
		END 

	,MAX(RIGHT([Fiscal Week],2)) OVER (PARTITION BY [Fiscal Year]) AS [WeeksInYear]

    ,[Fiscal Year]
	,[Fiscal Quarter]
	,[Fiscal Quarter Week] = CONCAT(
							[Fiscal Quarter],
							'-WK',
							RIGHT(CONCAT('00',ROW_NUMBER() OVER (PARTITION BY [Fiscal Quarter] ORDER BY [Fiscal Week])),2)
							)
	,[Fiscal Quarter Wk] = CONCAT('Wk ', ROW_NUMBER() OVER (PARTITION BY [Fiscal Quarter] ORDER BY [Fiscal Week]))

	,[Fiscal Quarter Week No] = ROW_NUMBER() OVER (PARTITION BY [Fiscal Quarter] ORDER BY [Fiscal Week])
	,[Fiscal Quarter Short] = RIGHT([Fiscal Quarter],2)
	,[Fiscal Period]
	,[Fiscal Period Week] = CONCAT(
							[Fiscal Period],
							'/',
							RIGHT(CONCAT('00',ROW_NUMBER() OVER (PARTITION BY [Fiscal Period] ORDER BY [Fiscal Week])),2)
							)

	,[Fiscal Period Wk] = CONCAT('Wk ', ROW_NUMBER() OVER (PARTITION BY [Fiscal Period] ORDER BY [Fiscal Week]))

	,[Fiscal Period Week No] = ROW_NUMBER() OVER (PARTITION BY [Fiscal Period] ORDER BY [Fiscal Week])

FROM 	
	(SELECT DISTINCT 
		[Fiscal Year],
		[Fiscal Qtr/Year] AS [Fiscal Quarter],
		[TM1_Fiscal Per/Year] AS [Fiscal Period],
		[TM1_Fiscal_WeekinYear] AS [Fiscal Week],
		REPLACE([Prior Year Fiscal WeekinYear],'-','') AS [Fiscal Week PY]
	FROM 
		[dbo].[Date_FiscalDateLookup]
	WHERE 
		[Fiscal Year] >= CONVERT(varchar(4),YEAR(GetDate()) - 1)
		AND
		[Fiscal Year] <= CONVERT(varchar(4),YEAR(GetDate()) )
	) A
)

SELECT DISTINCT
	-- Week
     CTE_DATES.[Fiscal Week]

	,CONCAT(
			'Wk: ',
			FORMAT(MIN(CONVERT(date,[DayOfCalendarDate])) OVER (PARTITION BY [TM1_Fiscal_WeekinYear]),'MM/dd/yy'),
			' - ',
			FORMAT(MAX(CONVERT(date,[DayOfCalendarDate])) OVER (PARTITION BY [TM1_Fiscal_WeekInYear]),'MM/dd/yy')
			) 
		AS [Fiscal Week Name]

	,CTE_DATES.[Fiscal Week PY]
	,CTE_DATES.[Fiscal Week PY Q4 Leap Year]

	-- Period
	,CTE_DATES.[Fiscal Period]
	,CTE_DATES.[Fiscal Period Week No]
	,CTE_DATES.[Fiscal Period Week]
	,CTE_DATES.[Fiscal Period Wk]

	-- Quarter
	,CTE_DATES.[Fiscal Quarter]
	,CTE_DATES.[Fiscal Quarter Short]
	,CTE_DATES.[Fiscal Quarter Week No]
	,CTE_DATES.[Fiscal Quarter Week]
	,CTE_DATES.[Fiscal Quarter Wk]

	-- Year
	,CTE_DATES.[Fiscal Year]
	
	-- Offsets
	,CONVERT(bit,CASE WHEN CONVERT(date,GetDate()) BETWEEN CONVERT(date,[First Day of Fiscal Year]) AND CONVERT(date,[Last Day of Fiscal Year]) THEN 1 ELSE 0 END) AS IsCurrentYear
	,CONVERT(bit,CASE WHEN CONVERT(date,GetDate()) BETWEEN CONVERT(date,[First Day of Fiscal Quarter]) AND CONVERT(date,[Last Day of Fiscal Quarter]) THEN 1 ELSE 0 END) AS IsCurrentQuarter
	,CONVERT(bit,CASE WHEN CONVERT(date,GetDate()) BETWEEN CONVERT(date,[First Day of Fiscal Period]) AND CONVERT(date,[Last Day of Fiscal Period]) THEN 1 ELSE 0 END) AS IsCurrentPeriod
	,CONVERT(bit,CASE WHEN CONVERT(date,GetDate()) BETWEEN MIN(CONVERT(date,[DayOfCalendarDate])) OVER (PARTITION BY [TM1_Fiscal_WeekinYear]) AND  MAX(CONVERT(date,[DayOfCalendarDate])) OVER (PARTITION BY [TM1_Fiscal_WeekinYear]) THEN 1 ELSE 0 END) IsCurrentWeek	
	,DATEDIFF(WEEK,DATEADD(d,0,GetDate()),MAX(CONVERT(date,[DayOfCalendarDate])) OVER (PARTITION BY [TM1_Fiscal_WeekinYear])) AS OffsetWeek
	,DATEDIFF(MONTH,DATEADD(d,0,GetDate()),MAX(CONVERT(date,[DayOfCalendarDate])) OVER (PARTITION BY [TM1_Fiscal_WeekinYear])) AS OffsetPeriod
	,DATEDIFF(QUARTER,DATEADD(d,0,GetDate()),MAX(CONVERT(date,[DayOfCalendarDate])) OVER (PARTITION BY [Fiscal Qtr/Year]))  AS OffsetQuarter
	,@DatasetRefresh AS DatasetRefresh
FROM 
	CTE_DATES 
	INNER JOIN 
	[dbo].[Date_FiscalDateLookup] LU
	ON 
	CTE_DATES.[Fiscal Week] = LU.[TM1_Fiscal_WeekinYear]
WHERE
	-- Filter to Current Quarter
	CONVERT(bit,CASE WHEN CONVERT(date,GetDate()) BETWEEN CONVERT(date,[First Day of Fiscal Quarter]) AND CONVERT(date,[Last Day of Fiscal Quarter]) THEN 1 ELSE 0 END) = 1

ORDER BY 
	CTE_DATES.[Fiscal Week]
