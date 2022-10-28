select Scenario
     , [Fiscal Quarter]
     , case
           when Scenario like '%QRF ____' then
               concat('FY', right(Scenario, 2), ' ', left(Scenario, 2), ' QRF TSFR ADJ')
           else
               Scenario
       end                           Version
     , format(sum([Value]), '#,000') as Revenue
from [dbo].[TM1_Revenue_Planning_Consolidated_Final]
where scenario in ( 'Actuals', 'Q2 QRF 2022', 'Outlook - Current' )
      and [Fiscal Quarter] >= '2021 Q1'
      and [Fiscal Quarter] <= '2022 Q4'
      and [External BU - Name] in ( 'Digital Media (XR)', 'Publishing & Advertising (XR)', 'Other Solutions (XR)' )
      and [Route To Market] = 'Adobe.com Product'
      and [FX Conversion] = 'USD'
      and [Measures] = 'Adjusted Net New Revenue'
group by Scenario
       , [Fiscal Quarter]
order by scenario
       , [Fiscal Quarter]


select [Version]
     , [Fiscal Qtr/Year]
     , format(sum([Value USD @ Plan Rates]), '#,000') Expense
from vw_Expense_Final_DME
where [Version] in ( 'Actuals', 'FY22 Q2 QRF TSFR ADJ' )
      and [Cost Element Grp Desc] = 'Credit Card Fees'
      and [Fiscal Year] >= '2021'
group by [Version]
       , [Fiscal Qtr/Year]
order by [Version]
       , [Fiscal Qtr/Year]