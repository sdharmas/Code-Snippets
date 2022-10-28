/*
ARR Revenue Product Hierarchy
------------------------------
Steps:
0) Clear any temp tables from previous execution (if they exist)

1) Populate meta-data into #hierarchy temp table describing data and filter(s) of ARR to generate hierarchy leaf data

2) Populate ARR data into #arr temp table
   (contains all special logic required, and performs aggregation)

3) Store SQL Template in @sqlTemplate variable
   (used in creating overall SQL command, contains tokens that are replaced in a cursor with meta-data fields)

4) Iterate though #hierarchy and build @sqlResult using @sqlTemplate and performing token replacement

5) Execute the sql string using sp_executesql 

*/

SET NOCOUNT ON 

-- 0) Drop Temp Tables If Exist
DROP TABLE IF EXISTS #hierarchy
DROP TABLE IF EXISTS #arr

-- 1) Hierarchy Meta-Data 
SELECT 
	Hierarchy,
	Display,
	DisplayOrder,
	Indentation,
	SQL_Filter,
	Multiplier
INTO
	#hierarchy
FROM
	(
	SELECT 'Product Category' AS Hierarchy,'[RoutetoMarket2] = ''SMB & Consumer''' AS SQL_Filter,'Total C&B' AS Display,1 AS DisplayOrder,0 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'[Enterprise BU] = ''EB10''' AS SQL_Filter,'Creative Cloud' AS Display,2 AS DisplayOrder,0 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10'' AND Offerings = ''Acrobat CC''' AS SQL_Filter,'Creative Cloud' AS Display,2 AS DisplayOrder,0 AS Indentation,-1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10''  AND NOT (Offerings2 = ''Acrobat CC'')' AS SQL_Filter,'Core CC' AS Display,3 AS DisplayOrder,5 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'(InternalSegment = ''IS10'' AND Offerings2 = ''Commercial Individual'' AND [App Names] = ''All Apps'')OR(InternalSegment = ''IS10'' AND Offerings2 = ''Commercial Team'' AND [App Names] = ''All Apps'')OR(InternalSegment = ''IS10'' AND Offerings2 = ''Students'' AND [App Names] = ''All Apps'')OR(InternalSegment = ''IS10'' AND Offerings2 = ''Institutions'' AND Offerings = ''HED'' AND [App Names] = ''All Apps'')OR(InternalSegment = ''IS10'' AND [App Names] = ''K12'' AND Offerings2 IN (''Commercial Individual'',''Commercial Team'',''Institutions'',''Photography'',''Students''))OR(InternalSegment = ''IS10'' AND [App Names] = ''EEA'' AND Offerings2 = ''Institutions'')OR(InternalSegment = ''IS10'' AND [App Names] = ''All Apps'' AND Offerings2 = ''Stock'')' AS SQL_Filter,'All Apps' AS Display,4 AS DisplayOrder,10 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10'' AND Offerings2 = ''Commercial Individual'' AND [App Names] = ''All Apps''' AS SQL_Filter,'CCI' AS Display,5 AS DisplayOrder,15 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10'' AND Offerings2 = ''Commercial Team'' AND [App Names] = ''All Apps''' AS SQL_Filter,'CCT' AS Display,6 AS DisplayOrder,15 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10'' AND Offerings2 = ''Students'' AND [App Names] = ''All Apps''' AS SQL_Filter,'STE' AS Display,7 AS DisplayOrder,15 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'(InternalSegment = ''IS10'' AND Offerings2 = ''Institutions'' AND Offerings = ''HED'' AND [App Names] = ''All Apps'')OR(InternalSegment = ''IS10'' AND [App Names] = ''K12'' AND Offerings2 IN (''Commercial Individual'',''Commercial Team'',''Institutions'',''Photography'',''Students''))OR(InternalSegment = ''IS10'' AND [App Names] = ''EEA'' AND Offerings2 = ''Institutions'')' AS SQL_Filter,'HED/K12' AS Display,8 AS DisplayOrder,15 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10'' AND Offerings2 = ''Institutions'' AND Offerings = ''HED'' AND [App Names] = ''All Apps''' AS SQL_Filter,'HED' AS Display,9 AS DisplayOrder,20 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10'' AND [App Names] = ''K12'' AND Offerings2 IN (''Commercial Individual'',''Commercial Team'',''Institutions'',''Photography'',''Students'')' AS SQL_Filter,'K12' AS Display,10 AS DisplayOrder,20 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10'' AND [App Names] = ''EEA'' AND Offerings2 = ''Institutions''' AS SQL_Filter,'EEA' AS Display,11 AS DisplayOrder,20 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10'' AND [App Names] = ''All Apps'' AND Offerings2 = ''Stock''' AS SQL_Filter,'Other' AS Display,12 AS DisplayOrder,15 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10'' AND ([App Names] in (''Photoshop'',''PSx'',''Photoshop Mobile'') OR Product IN (''Lightroom CC'',''Lightroom CC IAP'',''CCP Classic'',''CCP New''))' AS SQL_Filter,'Photo + Imaging' AS Display,13 AS DisplayOrder,10 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10'' AND [App Names] = ''Photoshop'' AND Offerings2 IN (''Commercial Individual'',''Commercial Team'',''Institutions'',''Photography'',''Students'')' AS SQL_Filter,'PS' AS Display,14 AS DisplayOrder,15 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10'' AND [App Names] = ''PSx''' AS SQL_Filter,'PsX' AS Display,15 AS DisplayOrder,15 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10'' AND [App Names] = ''Photoshop Mobile''  AND Offerings2 IN (''Commercial Individual'',''Commercial Team'',''Institutions'',''Photography'',''Students'')' AS SQL_Filter,'PS on iPad' AS Display,16 AS DisplayOrder,15 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10'' AND Product = ''Lightroom CC''' AS SQL_Filter,'Lr1TB' AS Display,17 AS DisplayOrder,15 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10'' AND Product IN (''Lightroom CC Mobile'',''Lightroom CC IAP'')' AS SQL_Filter,'LrMobile' AS Display,18 AS DisplayOrder,15 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10'' AND Product = ''Lightroom CC Mobile''' AS SQL_Filter,'CC Mobile' AS Display,19 AS DisplayOrder,20 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10'' AND Product = ''Lightroom CC IAP''' AS SQL_Filter,'CC IAP' AS Display,20 AS DisplayOrder,20 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10'' AND Product = ''CCP Classic'' AND Offerings2 IN (''Commercial Individual'',''Commercial Team'',''Institutions'',''Photography'',''Students'')' AS SQL_Filter,'CCP 20GB' AS Display,21 AS DisplayOrder,15 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10'' AND Product = ''CCP New''' AS SQL_Filter,'CCP 1TB' AS Display,22 AS DisplayOrder,15 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10'' AND (([App Names] IN (''Premiere Pro'',''Rush'')) OR ([App Names] = ''After Effects''  AND Offerings2 IN (''Commercial Individual'',''Commercial Team'',''Institutions'',''Photography'',''Students'')))' AS SQL_Filter,'Video Category' AS Display,23 AS DisplayOrder,10 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10'' AND [App Names] = ''Premiere Pro''' AS SQL_Filter,'PR Pro' AS Display,24 AS DisplayOrder,15 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10'' AND [App Names] = ''After Effects'' AND Offerings2 IN (''Commercial Individual'',''Commercial Team'',''Institutions'',''Photography'',''Students'')' AS SQL_Filter,'After Effects' AS Display,25 AS DisplayOrder,15 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10'' AND [App Names] = ''Rush''' AS SQL_Filter,'PRX (Rush)' AS Display,26 AS DisplayOrder,15 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10'' AND [App Names] IN (''Illustrator'',''Illustrator Mobile'',''InDesign'',''XD'',''Dimension'',''SUBD'')' AS SQL_Filter,'Design Category' AS Display,27 AS DisplayOrder,10 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10'' AND [App Names] = ''Illustrator'' AND Offerings2 IN (''Commercial Individual'',''Commercial Team'',''Institutions'',''Photography'',''Students'')' AS SQL_Filter,'Ai' AS Display,28 AS DisplayOrder,15 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10'' AND [App Names] = ''Illustrator Mobile'' AND Offerings2 IN (''Commercial Individual'',''Commercial Team'',''Institutions'',''Photography'',''Students'')' AS SQL_Filter,'AI iPad' AS Display,29 AS DisplayOrder,15 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10'' AND [App Names] = ''InDesign'' AND Offerings2 IN (''Commercial Individual'',''Commercial Team'',''Institutions'',''Photography'',''Students'')' AS SQL_Filter,'ID' AS Display,30 AS DisplayOrder,15 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10'' AND [App Names] = ''XD'' AND Offerings2 IN (''Commercial Individual'',''Commercial Team'',''Institutions'',''Photography'',''Students'')' AS SQL_Filter,'XD' AS Display,31 AS DisplayOrder,15 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10'' AND [App Names] IN (''Dimension'',''SUBD'') AND Offerings2 IN (''Commercial Individual'',''Commercial Team'',''Institutions'',''Photography'',''Students'')' AS SQL_Filter,'Substance/3di' AS Display,32 AS DisplayOrder,15 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10'' AND [App Names] = ''Dimension'' AND Offerings2 IN (''Commercial Individual'',''Commercial Team'',''Institutions'',''Photography'',''Students'')' AS SQL_Filter,'Dimension' AS Display,33 AS DisplayOrder,20 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10'' AND Offerings2 IN (''Commercial Individual'',''Commercial Team'',''Institutions'',''Photography'',''Students'') AND [App Names] = ''Mobile Design Bundle''' AS SQL_Filter,'Mobile Design Bundle' AS Display,34 AS DisplayOrder,15 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10'' AND [App Names] = ''SUBD'' AND Offerings2 IN (''Commercial Individual'',''Commercial Team'',''Institutions'',''Photography'',''Students'')' AS SQL_Filter,'SUBD' AS Display,35 AS DisplayOrder,20 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10'' AND [App Names] IN (''Spark'',''CC Express'')' AS SQL_Filter,'Multimedia' AS Display,36 AS DisplayOrder,10 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10'' AND [App Names] IN (''Spark'',''CC Express'')' AS SQL_Filter,'CC Express + Spark' AS Display,37 AS DisplayOrder,15 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10'' AND [App Names] = ''Other Single Apps'' AND Offerings2 IN (''Commercial Individual'',''Commercial Team'',''Institutions'',''Photography'',''Students'')' AS SQL_Filter,'Other Single Apps' AS Display,38 AS DisplayOrder,10 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10'' AND [Offerings2] = ''CSMB ETLA''' AS SQL_Filter,'Creative CSMB ETLA' AS Display,39 AS DisplayOrder,10 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS18'' AND [App Names] = ''Stock'' ' AS SQL_Filter,'Stock ARR' AS Display,40 AS DisplayOrder,5 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'1 = 2 ' AS SQL_Filter,'Gross CP/OD' AS Display,41 AS DisplayOrder,5 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS18''' AS SQL_Filter,'Stock Net New BoB (CSMB)' AS Display,42 AS DisplayOrder,5 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10'' AND Offerings2 = ''Commercial Team''' AS SQL_Filter,'CCT Total' AS Display,43 AS DisplayOrder,5 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'([Enterprise BU] = ''EB15'' ) OR (InternalSegment = ''IS10'' AND Offerings = ''Acrobat CC'')' AS SQL_Filter,'Document Cloud' AS Display,44 AS DisplayOrder,0 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'(InternalSegment = ''IS15'') OR (InternalSegment = ''IS10'' AND Offerings = ''Acrobat CC'')' AS SQL_Filter,'Acrobat' AS Display,45 AS DisplayOrder,5 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10'' AND Offerings = ''Acrobat CC''' AS SQL_Filter,'Acrobat CC' AS Display,46 AS DisplayOrder,10 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS15'' AND [Product] = ''Acrobat DC'' AND RouteToMarketID NOT IN (''App Store'')' AS SQL_Filter,'Acrobat DC' AS Display,47 AS DisplayOrder,10 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS15'' AND [Product] = ''Acrobat DCE'' AND RouteToMarketID NOT IN (''App Store'')' AS SQL_Filter,'Acrobat DCE' AS Display,48 AS DisplayOrder,10 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'(InternalSegment = ''IS10'' AND Offerings = ''Acrobat CC'')OR(InternalSegment = ''IS15'' AND [Product] = ''Acrobat DC'' AND RouteToMarketID NOT IN (''App Store''))OR(InternalSegment = ''IS15'' AND [Product] = ''Acrobat DCE'' AND RouteToMarketID NOT IN (''App Store''))' AS SQL_Filter,'Acrobat Std/Pro' AS Display,49 AS DisplayOrder,10 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'[Enterprise BU] = ''EB15'' AND Product = ''PDF Services''' AS SQL_Filter,'PDF Services' AS Display,50 AS DisplayOrder,10 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'RouteToMarketID = ''App Store'' AND Offerings2 = ''Acrobat DC''' AS SQL_Filter,'Acrobat Mobile' AS Display,51 AS DisplayOrder,10 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS15'' AND [App Names] = ''Acrobat + e-sign''' AS SQL_Filter,'Acrobat + e-Sign' AS Display,52 AS DisplayOrder,10 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS15'' AND [App Names] = ''ETLA''' AS SQL_Filter,'Doc Cloud CSMB ETLA' AS Display,53 AS DisplayOrder,10 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS17'' ' AS SQL_Filter,'Sign' AS Display,54 AS DisplayOrder,5 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS17''' AS SQL_Filter,'Sign Total' AS Display,55 AS DisplayOrder,0 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Category' AS Hierarchy,'InternalSegment = ''IS10'' AND Offerings2 = ''Acrobat CC''' AS SQL_Filter,'Acrobat CC Total' AS Display,56 AS DisplayOrder,0 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Ranges' AS Hierarchy,'1=1' AS SQL_Filter,'CC (excl. Stock & Stubstance)' AS Display,1 AS DisplayOrder,0 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Ranges' AS Hierarchy,'(InternalSegment = ''IS10'' AND [App Names] IN (''Dimension'',''SUBD''))OR(InternalSegment = ''IS18'')OR((InternalSegment = ''IS10'' AND Offerings = ''Acrobat CC'') OR (InternalSegment = ''IS15''))OR(InternalSegment = ''IS17'')OR([Enterprise BU] = ''XR10 - #'')' AS SQL_Filter,'CC (excl. Stock & Stubstance)' AS Display,1 AS DisplayOrder,0 AS Indentation,-1 AS Multiplier UNION 
	SELECT 'Product Ranges' AS Hierarchy,'InternalSegment = ''IS10'' AND [App Names] IN (''Dimension'',''SUBD'')' AS SQL_Filter,'Substance' AS Display,2 AS DisplayOrder,0 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Ranges' AS Hierarchy,'InternalSegment = ''IS18''' AS SQL_Filter,'Stock' AS Display,3 AS DisplayOrder,0 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Ranges' AS Hierarchy,'(InternalSegment = ''IS10'' AND Offerings = ''Acrobat CC'') OR (InternalSegment = ''IS15'')' AS SQL_Filter,'Acrobat' AS Display,4 AS DisplayOrder,0 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Ranges' AS Hierarchy,'InternalSegment = ''IS17''' AS SQL_Filter,'Sign' AS Display,5 AS DisplayOrder,0 AS Indentation,1 AS Multiplier UNION 
	SELECT 'Product Ranges' AS Hierarchy,'[Enterprise BU] = ''XR10 - #''' AS SQL_Filter,'Total' AS Display,6 AS DisplayOrder,0 AS Indentation,1 AS Multiplier 
	)  
	H
ORDER BY 
	Hierarchy,
	DisplayOrder

-- 2) #arr:  Aggregated ARR Result Set (all data, grouped)

SELECT  
	-- Attributes
	WK.FiscalWeekID,
	ARR.[Product] ,
	PRODUCT.Product1,
	PRODUCT.Product2,
	ARR.[Offerings],
	OFFERING.Offerings1,
	OFFERING.Offerings2,
	ARR.[App Names],	
	BU.[Enterprise BU],
	SEGMENT.[InternalSegment],
	ARR.[Scenario],
	ARR.[FX Conversion],
   UPPER(TRIM([Route to Market - Subscription])) AS [RouteToMarketID],
   ARR.[RoutetoMarket2],
   M2.Measures2Custom,
   M2.Measures2CustomOrderBy,

	-- Measures
	SUM(CASE WHEN ARR.[FX Conversion] = 'USD' AND ARR.[Measures3] = 'Net New' AND  ARR.[Type2] = 'Total ARR' THEN ARR.[Value] ELSE 0 END) AS [Value],

	  -- Actual ARR 
	  SUM(
	  CASE 
			WHEN ARR.[Scenario] = 'Actuals' AND ARR.[FX Conversion] = 'USD' AND WK.[OffsetWeek] < 0 AND [RoutetoMarket2] = 'SMB & Consumer' AND ARR.[Measures3] = 'Net New' AND  ARR.[Type2] = 'Total ARR' THEN [Value]
			WHEN ARR.[Scenario] = 'Actuals' AND ARR.[FX Conversion] = 'USD' AND WK.[OffsetQuarter] < 0 AND [RoutetoMarket2] = 'Enterprise' AND ARR.[Measures3] = 'Net New' AND   ARR.[Type2] = 'Total ARR' THEN [Value]
        ELSE
			0
		END
		)AS [Value_Actual],

		-- Prior Year ARR
		SUM(
		CASE 
			WHEN ARR.[Scenario] = 'Actuals' AND ARR.[FX Conversion] = 'USD Adjusted' AND ARR.[Measures3] = 'Net New' AND  ARR.[Type2] = 'Total ARR' THEN [Value]
		ELSE 
			0
		END
		) AS [Value_Actual_PriorYear],
	 	
	  -- Outlook ARR
	   SUM(
	   CASE 
			WHEN ARR.[Scenario] = 'Outlook - Current' AND ARR.[Measures3] = 'Net New' AND  ARR.[Type2] = 'Total ARR' THEN [Value]
		 ELSE 
			0
		END
		) AS [Value_Outlook],

	  -- Outlook Previous 
	   SUM(
	   CASE 
			WHEN ARR.[Scenario] = 'OL - Previous' AND ARR.[Measures3] = 'Net New' AND  ARR.[Type2] = 'Total ARR' THEN [Value]
		 ELSE 
			0
		END
		) AS [Value_Outlook_Previous],

	   
		-- QRF Snapshot 
		 SUM(CASE 
			WHEN ARR.[Scenario] = WK.[QRF_SnapshotName] AND ARR.[Measures3] = 'Net New' AND  ARR.[Type2] = 'Total ARR' THEN [Value]
		 ELSE 
			0
		END) AS [Value_QRF_Snapshot]

		-- QRF Current
		 ,SUM(CASE 
			WHEN ARR.[Scenario] = 'QRF - Current' AND ARR.[Measures3] = 'Net New' AND  ARR.[Type2] = 'Total ARR' THEN [Value]
		 ELSE 
			0
		END) AS [Value_QRF_Current]

		-- QRF Snapshot (for Actual Variance)
		,SUM(CASE 
			WHEN ARR.[Scenario] = WK.[QRF_SnapshotName] AND WK.[OffsetWeek] < 0  AND [RoutetoMarket2] = 'SMB & Consumer' AND ARR.[Measures3] = 'Net New' AND  ARR.[Type2] = 'Total ARR' THEN [Value]
			WHEN ARR.[Scenario] = WK.[QRF_SnapshotName] AND WK.[OffsetQuarter] < 0 AND [RoutetoMarket2] = 'Enterprise' AND ARR.[Measures3] = 'Net New' AND  ARR.[Type2] = 'Total ARR' THEN [Value]
        ELSE
			0
		END)  AS[Value_QRF_Snapshot_ForActVar]

		-- QRF Current (for Actual Variance) 
		,SUM(CASE 
			WHEN ARR.[Scenario] = 'QRF - Current' AND WK.[OffsetWeek] < 0  AND [RoutetoMarket2] = 'SMB & Consumer' AND ARR.[Measures3] = 'Net New' AND  ARR.[Type2] = 'Total ARR' THEN [Value]
			WHEN ARR.[Scenario] = 'QRF - Current' AND WK.[OffsetQuarter] < 0 AND [RoutetoMarket2] = 'Enterprise' AND ARR.[Measures3] = 'Net New' AND  ARR.[Type2] = 'Total ARR' THEN [Value]
        ELSE
			0
		END)  AS [Value_QRF_Current_ForActVar]

     , MAX(ARR.[LoadDate]) AS [LoadDate]
INTO 
	#arr
FROM
	dbo.[vw_TM1_Subs_Alex] ARR

		-- Limit Dates
	 INNER JOIN 
	  (
		SELECT DISTINCT
			 [TM1_Fiscal_WeekinYear] AS [FiscalWeekID]
  			,concat(RIGHT([Fiscal Qtr/Year],2), ' QRF ',LEFT([Fiscal Qtr/Year],4))   AS QRF_SnapshotName
			,DATEDIFF(WEEK,DATEADD(d,0,GetDate()),MAX(CONVERT(date,[DayOfCalendarDate])) OVER (PARTITION BY [TM1_Fiscal_WeekinYear])) AS OffsetWeek
			,DATEDIFF(MONTH,DATEADD(d,0,GetDate()),MAX(CONVERT(date,[DayOfCalendarDate])) OVER (PARTITION BY [TM1_Fiscal_WeekinYear])) AS OffsetPeriod
			,DATEDIFF(QUARTER,DATEADD(d,0,GetDate()),MAX(CONVERT(date,[DayOfCalendarDate])) OVER (PARTITION BY [Fiscal Qtr/Year]))  AS OffsetQuarter
		FROM 
			[dbo].[Date_FiscalDateLookup]
		WHERE
			[Fiscal Year] >=  convert(varchar(4),YEAR(GetDate()) - 2)
			AND
			[Fiscal Year] <= convert(varchar(4),YEAR(GetDate()) + 1)
	) 
	WK
	ON
	ARR.[Fiscal Week] =  WK.[FiscalWeekID]

	LEFT JOIN 
	-- Enterprise Business Unit
	(SELECT DISTINCT [Enterprise BU], [Enterprise BU - Name] FROM TM1_Revenue_PlanningConsolidatedProfitCenter) BU
	ON
	ARR.[Enterprise BU - Name] = BU.[Enterprise BU - Name]

	LEFT JOIN 
	-- Internal Segment
	(SELECT DISTINCT InternalSegment, [InternalSegment - Name] FROM TM1_Revenue_PlanningConsolidatedProfitCenter) SEGMENT
	ON
	ARR.[InternalSegment - Name] = SEGMENT.[InternalSegment - Name]

	LEFT JOIN 
	-- Offerings 
	dbo.[TM1_Revenue_PlanningSubscriptionsOfferings] OFFERING
	ON
	ARR.Offerings = OFFERING.Offerings

	LEFT JOIN 
	-- Product  
	dbo.[TM1_Revenue_PlanningSubscriptionsProduct] PRODUCT
	ON
	ARR.Product = PRODUCT.Product

	-- Measures 2 Custom 
	LEFT JOIN 
	(
	SELECT DISTINCT 
 		 ISNULL(Measures2,'#')                  AS Measures2
		,CASE Measures2 
			WHEN 'Net Migrations'				THEN 'Migrat'
			WHEN 'Beginning'					THEN 'Beginning'
			WHEN 'Attrition'					THEN 'Cancel'
			WHEN 'Gross New (Sell In)'			THEN 'Gross'
			WHEN 'Gross New (ASV)'				THEN 'Gross New (ASV)'
			WHEN 'Gross New (Usage Based)'		THEN 'Gross New (Usage Based)'
			WHEN 'Enterprise ARR Adjustments'	THEN 'Ent ARR Adj'
			WHEN 'Other QE Adjustments'			THEN 'Other'
		ELSE
			'Other'
		END AS 
			Measures2Custom

		,CASE Measures2 
			WHEN 'Net Migrations'				THEN 3
			WHEN 'Beginning'					THEN 4
			WHEN 'Attrition'					THEN 2
			WHEN 'Gross New (Sell In)'			THEN 1
			WHEN 'Gross New (ASV)'				THEN 5
			WHEN 'Gross New (Usage Based)'		THEN 6
			WHEN 'Enterprise ARR Adjustments'	THEN 7
			WHEN 'Other QE Adjustments'			THEN 8
		ELSE
			8
		END AS 
			Measures2CustomOrderBy

	FROM 
		[dbo].[vw_TM1_Subs_Alex] A
	)
	M2
	ON
	ISNULL(ARR.Measures2,'#') = M2.Measures2

GROUP BY 
	WK.FiscalWeekID,
	ARR.[Product] ,
	PRODUCT.Product1,
	PRODUCT.Product2,
	ARR.[Offerings],
	OFFERING.Offerings1,
	OFFERING.Offerings2,
	ARR.[App Names],	
	BU.[Enterprise BU],
	SEGMENT.[InternalSegment],
	ARR.[Scenario],
	ARR.[FX Conversion],
    UPPER(TRIM([Route to Market - Subscription])), -- [RouteToMarketID]
	ARR.[RoutetoMarket2],
    M2.Measures2Custom,
    M2.Measures2CustomOrderBy

-- 3) SQL Template

DECLARE @sqlTemplate nvarchar(max) = 
'
SELECT 
	''[TOKEN_HIERARCHY]''	AS [Hierarchy],
	''[TOKEN_DISPLAY]''		AS [Display],
	[TOKEN_DISPLAY_ORDER]	AS [DisplayOrder],
	[TOKEN_INDENTATION]		AS [DisplayIndentation],
	[FiscalWeekID],
	[Product] ,
	[Product1],
	[Product2],
	[Offerings],
	[Offerings1],
	[Offerings2],
	[App Names],	
	[Enterprise BU],
	[InternalSegment],
	[Scenario],
	[FX Conversion],
	[RouteToMarketID],
	[RoutetoMarket2],
	[Measures2Custom],
    [Measures2CustomOrderBy],
	SUM([Value] * [TOKEN_MULTIPLIER]) AS [Value],
	SUM([Value_Actual] * [TOKEN_MULTIPLIER]) AS [Value_Actual],
	SUM([Value_Actual_PriorYear] * [TOKEN_MULTIPLIER]) AS [Value_Actual_PriorYear],
	SUM([Value_Outlook] * [TOKEN_MULTIPLIER]) AS [Value_Outlook],
	SUM([Value_Outlook_Previous] * [TOKEN_MULTIPLIER]) AS [Value_Outlook_Previous],
	SUM([Value_QRF_Current] * [TOKEN_MULTIPLIER]) AS [Value_QRF_Current],
	SUM([Value_QRF_Snapshot] * [TOKEN_MULTIPLIER]) AS [Value_QRF_Snapshot],
	SUM([Value_QRF_Current_ForActVar] * [TOKEN_MULTIPLIER]) AS [Value_QRF_Current_ForActVar],
	SUM([Value_QRF_Snapshot_ForActVar] * [TOKEN_MULTIPLIER]) AS [Value_QRF_Snapshot_ForActVar],
	MAX(LoadDate) AS [LoadDate]
FROM 
	#arr 
WHERE
	[TOKEN_SQL_FILTER]
GROUP BY 
	[FiscalWeekID],
	[Product],
	[Product1],
	[Product2],
	[Offerings],
	[Offerings1],
	[Offerings2],
	[App Names],	
	[Enterprise BU],
	[InternalSegment],
	[Scenario],
	[FX Conversion],
	[RouteToMarketID],
	[RoutetoMarket2],
	[Measures2Custom],
    [Measures2CustomOrderBy]
'

-- 4) Iterate though #hierarchy and build @sqlResult 
DECLARE @sqlResult nvarchar(max) = ''
DECLARE @tempSQL nvarchar(max) = ''

DECLARE @Hierarchy varchar(max)
DECLARE @Display varchar(max)
DECLARE @DisplayOrder varchar(max)
DECLARE @Indentation varchar(max)
DECLARE @SQL_Filter varchar(max)
DECLARE @Multiplier varchar(max) 

DECLARE CUR_HIERARCHY CURSOR FOR SELECT Hierarchy,Display,DisplayOrder,Indentation,SQL_Filter, Multiplier FROM #hierarchy WHERE DisplayOrder = DisplayOrder ORDER BY DisplayOrder
OPEN CUR_HIERARCHY 
FETCH NEXT FROM CUR_HIERARCHY INTO @Hierarchy,@Display, @DisplayOrder, @Indentation, @SQL_Filter, @Multiplier

WHILE @@FETCH_STATUS = 0 

	BEGIN

		SET @tempSQL = REPLACE(@sqlTemplate,'[TOKEN_DISPLAY]',@Display)
		SET @tempSQL = REPLACE(@tempSQL, '[TOKEN_DISPLAY_ORDER]',@DisplayOrder)
		SET @tempSQL = REPLACE(@tempSQL,'[TOKEN_INDENTATION]',@Indentation)
		SET @tempSQL = REPLACE(@tempSQL,'[TOKEN_SQL_FILTER]',@SQL_Filter)
		SET @tempSQL = REPLACE(@tempSQL,'[TOKEN_MULTIPLIER]',@Multiplier)
		SET @tempSQL = REPLACE(@tempSQL,'[TOKEN_HIERARCHY]',@Hierarchy)
	
		SET @sqlResult = @sqlResult + @tempSQL + CHAR(13) + CHAR(13) + ' UNION ALL ' + CHAR(13) + CHAR(13)
	    RAISERROR('%s',10,1,@tempSQL) WITH NOWAIT

		FETCH NEXT FROM CUR_HIERARCHY INTO @Hierarchy,@Display, @DisplayOrder, @Indentation, @SQL_Filter, @Multiplier

	END

CLOSE CUR_HIERARCHY
DEALLOCATE CUR_HIERARCHY

DECLARE @length INT = LEN(@sqlResult) - 13
DECLARE @finalSQL nvarchar(max) = SUBSTRING(@sqlResult,1, @length)

DECLARE @groupedSQL nvarchar(max) = 
'
SELECT 
	[Hierarchy],
	[Display],
	[DisplayOrder],
	[DisplayIndentation],
	[FiscalWeekID],
	[Product] ,
	[Product1],
	[Product2],
	[Offerings],
	[Offerings1],
	[Offerings2],
	[App Names],	
	[Enterprise BU],
	[InternalSegment],
	[Scenario],
	[FX Conversion],
	[RouteToMarketID],
	[RoutetoMarket2],
	[Measures2Custom],
    [Measures2CustomOrderBy],
	SUM([Value]) AS [Value],
	SUM([Value_Actual]) AS [Value_Actual],
	SUM([Value_Actual_PriorYear]) AS [Value_Actual_PriorYear],
	SUM([Value_Outlook]) AS [Value_Outlook],
	SUM([Value_Outlook_Previous]) AS [Value_Outlook_Previous],
	SUM([Value_QRF_Current]) AS [Value_QRF_Current],
	SUM([Value_QRF_Snapshot]) AS [Value_QRF_Snapshot],
	SUM([Value_QRF_Current_ForActVar]) AS [Value_QRF_Current_ForActVar],
	SUM([Value_QRF_Snapshot_ForActVar]) AS [Value_QRF_Snapshot_ForActVar],
	MAX(LoadDate) AS [LoadDate]
FROM 
	('
	+ @finalSQL + 
	')
	SUB
GROUP BY 
	[Hierarchy],
	[Display],
	[DisplayOrder],
	[DisplayIndentation],	
	[FiscalWeekID],
	[Product],
	[Product1],
	[Product2],
	[Offerings],
	[Offerings1],
	[Offerings2],
	[App Names],	
	[Enterprise BU],
	[InternalSegment],
	[Scenario],
	[FX Conversion],
	[RouteToMarketID],
	[RoutetoMarket2],
	[Measures2Custom],
    [Measures2CustomOrderBy]
'
EXEC sp_executesql @groupedSQL

