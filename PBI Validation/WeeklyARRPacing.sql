select [Scenario]
     , [fiscal week]
     , [RoutetoMarket2]
     , round(sum(Value) / 1e6, 1) as ARR
from [dbo].[vw_TM1_Subs_Dash]
where [RoutetoMarket2] in ( 'SMB & Consumer' )
      and [Measures3] = 'Net New'
      and [Scenario] in ( 'Outlook - Current', 'Actuals' )
      and [FX Conversion] = ('USD Current Plan Rate')
      and [Fiscal Quarter] = '2022 Q1'
      and Type2 = 'Total ARR'
group by [Scenario]
       , [fiscal week]
       , [RoutetoMarket2]
order by [Scenario], [Fiscal Week]     