select [Scenario]
     , [Route to Market - Subscription]
     , [LoadDate]
     , [Measures2]
     , [Type2]
     , [Fiscal Quarter]
     , 
     format(
         sum([Value])
         ,'N0') 
         as 'New ASV/VIP'
-- into #ARR
from [FINANCE_SYSTEMS].[dbo].[vw_TM1_Subs_Dash]
where [Fiscal Quarter] = [Current Quarter]
      and [Scenario] in ( 'Actuals', 'Outlook - Current' )
      and Measures2 = 'Gross New (Sell In)'
      and [Route to Market - Subscription] in ( 'Phone - Named', 'Reseller - Named' )
      and [FX Conversion] = 'USD Current Plan Rate'
group by [Scenario]
       , [Route to Market - Subscription]
       , [LoadDate]
       , [Measures2]
       , [Type2]
       , [Fiscal Quarter]
order by [Scenario]       

select [Scenario]
    --  , [Route to Market - Subscription]
     , [LoadDate]
     , [Measures2]
     , [Type2]
     , [Fiscal Quarter]
     , 
     format(
         sum([Value])
         ,'N0') 
         as 'New ASV/VIP'
-- into #ARR
from [FINANCE_SYSTEMS].[dbo].[vw_TM1_Subs_Dash]
where [Fiscal Quarter] = [Current Quarter]
      and [Scenario] in ( 'Actuals', 'Outlook - Current' )
      and Measures2 = 'Gross New (Sell In)'
      and [Route to Market - Subscription] in ( 'Phone - Named', 'Reseller - Named' )
      and [FX Conversion] = 'USD Current Plan Rate'
group by [Scenario]
    --    , [Route to Market - Subscription]
       , [LoadDate]
       , [Measures2]
       , [Type2]
       , [Fiscal Quarter]
order by [Scenario]   


