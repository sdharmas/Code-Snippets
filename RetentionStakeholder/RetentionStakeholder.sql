with Tbl as (
SELECT [Scenario]
	,[FX Conversion]
	,[RoutetoMarket1]
	,[Route to Market - Subscription]
	,[Type1]
	,[Type2]
	,[Measures2]
	,[Measures1]
	,[RegularVsPromo1]
	,[Market Area - Name]
	,[Fiscal Quarter]
	,[Fiscal Week]
	,[LoadDate]
	,sum([Value]) AS Value
FROM [FINANCE_SYSTEMS].[dbo].[TM1_Revenue_Planning_SubscriptionsFinal]
WHERE ([Scenario] = 'QRF - Current')
	AND ([RoutetoMarket1] <> 'Enterprise')
	AND ([RoutetoMarket1] <> 'Phone - Named')	
	AND ([RoutetoMarket1] <> 'Reseller - Named')	
	AND ([Measures2] = 'Attrition')
	AND [Ind vs Team vs Ent] <> 'Not Assigned'
	AND [Market Area - Name] NOT LIKE '#'
	AND (
		[Product] <> 'CP Default'
		AND [Product] <> 'CP001'
		AND [Product] <> 'CP005'
		AND [Product] <> 'CP016'
		AND [Product] <> 'CP040'
		AND [Product] <> 'CP080'
		AND [Product] <> 'CP150'
		AND [Product] <> 'CP500'
		AND [Product] <> 'LIC'
		AND [Product] <> 'Shrink'
		AND [Product] <> 'Stock On Demand'
		)
	AND ([Offerings] <> 'CSMB ETLA')
	AND (
		[App Names] <> 'EEA'
		AND [App Names] <> 'ETLA'
		)
	AND (
		[Type2] = 'Total ARR'
		OR [Type2] = 'Total Units'
		)
	AND (
		[Fiscal Quarter] IN (
			'2022 Q1'
			,'2022 Q2'
			,'2022 Q3'
			,'2022 Q4'
			)
		)
GROUP BY [Scenario]
	,[FX Conversion]
	,[RoutetoMarket1]
	,[Route to Market - Subscription]
	,[Type1]
	,[Type2]

	,[Measures2]
	,[Measures1]
	,[RegularVsPromo1]
	,[Market Area - Name]
	,[Fiscal Quarter]
	,[Fiscal Week]
	,[LoadDate]
	)
SELECT 
[FX Conversion]
, [Measures2] 
, sum([2022 Q1]) as Q1
, sum([2022 Q2]) as Q2
, sum([2022 Q3]) as Q3
, sum([2022 Q4]) as Q4
FROM Tbl
pivot(
	sum([Value]) for Tbl.[Fiscal Quarter] in ([2022 Q1]
	, [2022 Q2]
	, [2022 Q3]
	, [2022 Q4])
) as QuarterPivot
group by 
[FX Conversion]
, [Measures2] 

