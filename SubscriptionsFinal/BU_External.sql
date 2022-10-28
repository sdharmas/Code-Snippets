-- BU External
SELECT 
	ISNULL([BU_ExternalID],'#')           AS [BU_ExternalID],
	ISNULL(MAX([BU External Code]),'N/A') AS [BU External Code],
	ISNULL(MAX([BU External]),'N/A')      AS [BU External]
FROM 
(
	-- Business Unit External 
	SELECT DISTINCT 
		  UPPER(TRIM([EXT. REPORTING BU NAME])) AS [BU_ExternalID],
		 [EXT. REPORTING BU]					AS [BU External Code],
		 [EXT. REPORTING BU NAME]				AS [BU External]
	FROM 
		dbo.vw_Master_Data_ProfitCenterHierarchy_Final
	WHERE
		TRIM(ISNULL([EXT. REPORTING BU NAME],'')) <> ''

	UNION 

	-- vw_TM1_Subs_Alex
	SELECT DISTINCT
		[External BU - Name]			AS [BU_ExternalID],
		''                              AS [BU External Code],
		[External BU - Name]			AS [BU External]
	FROM 
		dbo.vw_TM1_Subs_Alex 

	UNION 

	-- TM1_Revenue_Planning_Consolidated_Final
	SELECT DISTINCT
		[External BU - Name]			AS [BU_ExternalID],
		[External BU]					AS [BU External Code],
		[External BU - Name]            AS [BU External]
	FROM 
		dbo.TM1_Revenue_Planning_Consolidated_Final

		UNION 

	-- TM1_Revenue_Planning_SubscriptionsFinal
	SELECT DISTINCT 
		[External BU - Name]		 AS [BU_ExternalID],
		[External BU]				 AS [BU External Code],
		[External BU - Name]         AS [BU External]
	FROM 
		dbo.TM1_Revenue_Planning_SubscriptionsFinal
	)
	BU
GROUP BY 
	ISNULL([BU_ExternalID],'#')
ORDER BY 
	[BU_ExternalID]