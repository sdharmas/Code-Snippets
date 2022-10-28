with TblRevenue
as (select Scenario
         , [Fiscal Quarter]
         , concat(left([Fiscal Quarter], 4), '-', right([Fiscal Quarter], 2)) 'Fiscal Qtr/Year'
         , case
               when Scenario like '%QRF ____' then
                   concat('FY', right(Scenario, 2), ' ', left(Scenario, 2), ' QRF TSFR ADJ')
               when Scenario like '%Outlook%' then
                   'Forecast'
               else
                   Scenario
           end                                                                Version
         , format(sum([Value]), '#,000')                                      as Revenue
    from [dbo].[TM1_Revenue_Planning_Consolidated_Final]
    where scenario in ( 'Actuals', 'Q2 QRF 2022', 'Outlook - Current' )
          and [Fiscal Quarter] >= '2021 Q1'
          and [Fiscal Quarter] <= '2022 Q4'
          and [External BU - Name] in ( 'Digital Media (XR)', 'Publishing & Advertising (XR)', 'Other Solutions (XR)' )
          and [Route To Market] = 'App Store'
          and [FX Conversion] = 'USD'
          and [Measures] = 'Adjusted Net New Revenue'
    group by Scenario
           , [Fiscal Quarter])
   , TblExpense
as (select [Version]
         , [Fiscal Qtr/Year]
         , format(sum([Value USD @ Plan Rates]), '#,000') Expense
    from vw_Expense_Final_DME
    where [Version] in ( 'Actuals', 'Forecast', 'FY22 Q2 QRF TSFR ADJ' )
          and [Cost Element Desc] = 'Apps Store Fees'
          and [Fiscal Year]
          between '2021' and '2022'
    group by [Version]
           , [Fiscal Qtr/Year])
select [Rev].[Fiscal Qtr/Year]
     , Rev.[Version]
     , Rev.Revenue
     , Exp.Expense
from TblRevenue           Rev
    inner join TblExpense Exp
        on Rev.[Version] = Exp.[Version]
           and Rev.[Fiscal Qtr/Year] = Exp.[Fiscal Qtr/Year]
order by [Version], [Fiscal Qtr/Year]           
