select [Scenario]
     , [RoutetoMarket2]
     , LoadDate
     , round(sum(Value) / 1e6, 1) as ARR
from [dbo].[vw_TM1_Subs_Dash]
where [RoutetoMarket2] in ( 'All Enterprise', 'SMB & Consumer' )
      and [Measures3] = 'Net New'
      and
      (
          (
              [Scenario] in ( 'Outlook - Current', 'OL - Previous', 'Q2 QRF 2022' )
              and [FX Conversion] = ('USD Current Plan Rate')
          )
          or
          (
              [Scenario] = 'Actuals'
              and [FX Conversion] = 'USD as Reported'
          )
      )
      and [Fiscal Quarter] = '2022 Q2'
      and Type2 = 'Total ARR'
group by LoadDate
       , [Scenario]
       , [RoutetoMarket2]
order by [Scenario]
       , RoutetoMarket2
