SELECT  [Version], [Employee Action Type], sum([Headcount]) as 'Heads' FROM [dbo].[vw_Headcount_Final]
WHERE [Version] = 'Actuals'
AND [Fiscal Qtr/Year] = '2020-Q4'
AND [Fiscal Per/Year] = '2020-12'
AND [Employee Group Name] = 'Regular'
AND ([Employee Status] = 'Active' OR [Employee Status] = 'On Leave' OR [Employee Status] = 'Outlook' OR [Employee Status] = '')
GROUP BY [Version], [Employee Action Type]

