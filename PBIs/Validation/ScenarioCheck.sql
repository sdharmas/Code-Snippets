declare @scenario NVARCHAR(30)  = 'Actuals'
declare @Quarter NVARCHAR(30)   = '2023 Q4'

select [Fiscal Quarter]
     , left(FINSYS_LoadDate, 19)       as LoadDate
     , round(sum(Value) / 1e6, 1) as ARR
from  [FINANCE_SYSTEMS].[dbo].[vw_TM1_Subs_Dash]               

where [Measures3] = 'Net New'
      and [Scenario] = @scenario
      and [Fiscal Quarter] = @Quarter
      and Type2 = 'Total ARR'
      and [FX Conversion] = 'USD Current Plan Rate'
group by [Fiscal Quarter]
     , left(FINSYS_LoadDate, 19)

