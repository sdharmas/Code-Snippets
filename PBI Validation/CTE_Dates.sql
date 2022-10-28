DECLARE @DatasetRefresh datetime = GetDate();
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
