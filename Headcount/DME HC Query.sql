
/****** Script for SelectTopNRows command from SSMS  ******/

WITH TblAggr
     AS (SELECT [Fiscal Per/Year], 
                [Version], 
                [Employee Action Type], 
                [Final Action Type], 
                [Employee Group Name], 
                [Employee Status], 
                [Load Date by Version], 
                SUM([Headcount]) AS Heads
         FROM [FINANCE_SYSTEMS].[dbo].[vw_Headcount_Final_LDAP_Filtered]
         WHERE [Version] = 'Forecast'
               AND [CCH Lvl 2 Name] = 'STILL'
               AND [Employee Action Type] = 'EE'
               AND [Employee Group Name] = 'Regular'
         GROUP BY [Fiscal Per/Year], 
                  [Version], 
                  [Employee Action Type], 
                  [Final Action Type], 
                  [Employee Group Name], 
                  [Employee Status], 
                  [Load Date by Version])
     SELECT [Load Date by Version], 
            [Version], 
            [Employee Action Type], 
            [Final Action Type], 
            [Employee Group Name], 
            [Employee Status], 
            [2021-07], 
            [2021-08], 
            [2021-09], 
            [2021-10], 
            [2021-11], 
            [2021-12], 
            [2022-01], 
            [2022-02], 
            [2022-03], 
            [2022-04], 
            [2022-05], 
            [2022-06], 
            [2022-07], 
            [2022-08], 
            [2022-09], 
            [2022-10], 
            [2022-11], 
            [2022-12]
     FROM TblAggr PIVOT(SUM(Heads) FOR [Fiscal Per/Year] IN([2021-07], 
                                                            [2021-08], 
                                                            [2021-09], 
                                                            [2021-10], 
                                                            [2021-11], 
                                                            [2021-12], 
                                                            [2022-01], 
                                                            [2022-02], 
                                                            [2022-03], 
                                                            [2022-04], 
                                                            [2022-05], 
                                                            [2022-06], 
                                                            [2022-07], 
                                                            [2022-08], 
                                                            [2022-09], 
                                                            [2022-10], 
                                                            [2022-11], 
                                                            [2022-12])) AS PivotTable;