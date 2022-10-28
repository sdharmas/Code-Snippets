USE [FINANCE_SYSTEMS]
GO

with Tbl
as (SELECT [Scenario]
         , [RoutetoMarket2]
         , round(sum(Value) / 1e6, 1) AS ARR
    FROM [dbo].[TM1_Revenue_Planning_SubscriptionsFinal]
    WHERE [RoutetoMarket2] IN ( 'Enterprise', 'SMB & Consumer' )
          AND [Measures3] = 'Net New'
          AND (
                  (
                      [Scenario] IN ( 'Outlook - Current', '2022 Plan' )
                      AND [FX Conversion] = ('USD Current Plan Rate')
                  )
                  OR (
                         [Scenario] = 'Actuals'
                         AND [FX Conversion] = 'USD as Reported'
                     )
              )
          AND [Fiscal Quarter] = '2022 Q1'
          AND Type2 = 'Total ARR'
    GROUP BY [Scenario]
           , [RoutetoMarket2]
   )
   , TblBreakout
as (select [RoutetoMarket2]
         , [Outlook - Current]
         , [2022 Plan]
         , [Actuals]
    from Tbl
        pivot
        (
            sum(ARR)
            for Tbl.Scenario in ([Actuals], [2022 Plan], [Outlook - Current])
        ) as scenario_pivot
   )
   , TblTotal
as (select 'Total'                  as "Route to Market 2"
         , sum([Outlook - Current]) "Outlook-Current"
         , sum([2022 Plan])         "2022 Plan"
         , sum([Actuals])           "Actuals"
    from TblBreakout
   )
   , TblUnion
as (select *
    from TblBreakout
    union
    select *
    from TblTotal
   )
select [RoutetoMarket2]
     , [Outlook - Current]
     , [2022 Plan]
     , round([Outlook - Current] - [2022 Plan], 1) as "vs Plan"
     , [Actuals]
from TblUnion;