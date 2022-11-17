-- remember to change the QRF scenario at the bottom

declare @CQtr varchar(10)

set @CQtr =
(
    select distinct [Current Quarter] from vw_TM1_Subs_Alex
)

select [FX Conversion]
     , [Scenario]
     , [Fiscal Quarter]
     , [Enterprise BU - Name]
     , [Route To Market 2]
     , Measures
     , [LoadDate]
     , sum([Value]) Value
from [FINANCE_SYSTEMS].[dbo].[TM1_Revenue_Planning_Consolidated_Final]
where [FX Conversion] = 'USD'
      and [Measures] in ( 'Adjusted Net New Revenue', 'Acrobat Revenue' )
      and [Scenario] in ( 'Actuals', 'Q4 QRF 2022' )
      and [Fiscal Quarter] < @CQtr
      and ([External BU] = 'XR10')
      and [Year] >= '2019'
group by [FX Conversion]
       , [Scenario]
       , [Fiscal Quarter]
       , [Enterprise BU - Name]
       , [Route To Market 2]
       , Measures
       , [LoadDate]
union all
select [FX Conversion]
     , [Scenario]
     , [Fiscal Quarter]
     , [Enterprise BU - Name]
     , [Route To Market 2]
     , Measures
     , [LoadDate]
     , sum([Value]) Value
from [FINANCE_SYSTEMS].[dbo].[TM1_Revenue_Planning_Consolidated_Final]
where [FX Conversion] = 'USD'
      and [Measures] in ( 'Adjusted Net New Revenue', 'Acrobat Revenue' )
      and [Scenario] = 'Outlook - Current'
      and [Fiscal Quarter] = @CQtr
      and ([External BU] = 'XR10')
      and [Year] >= '2019'
group by [FX Conversion]
       , [Scenario]
       , [Fiscal Quarter]
       , [Enterprise BU - Name]
       , [Route To Market 2]
       , Measures
       , [LoadDate]
union all
select [FX Conversion]
     , [Scenario]
     , [Fiscal Quarter]
     , [Enterprise BU - Name]
     , [Route To Market 2]
     , Measures
     , [LoadDate]
     , sum([Value]) Value
from [FINANCE_SYSTEMS].[dbo].[TM1_Revenue_Planning_Consolidated_Final]
where [FX Conversion] = 'USD'
      and [Measures] in ( 'Adjusted Net New Revenue', 'Acrobat Revenue' )
      and [Scenario] = 'Q4 QRF 2022'
      and [Fiscal Quarter] = @CQtr
      and ([External BU] = 'XR10')
      and [Year] >= '2019'
group by [FX Conversion]
       , [Scenario]
       , [Fiscal Quarter]
       , [Enterprise BU - Name]
       , [Route To Market 2]
       , Measures
       , [LoadDate]
union all
select [FX Conversion]
     , [Scenario]
     , [Fiscal Quarter]
     , [Enterprise BU - Name]
     , [Route To Market 2]
     , Measures
     , [LoadDate]
     , sum([Value]) Value
from [FINANCE_SYSTEMS].[dbo].[TM1_Revenue_Planning_Consolidated_Final]
where [FX Conversion] = 'USD'
      and [Measures] in ( 'Adjusted Net New Revenue', 'Acrobat Revenue' )
      and [Scenario] = 'FY23 Plan v2 submission'
      and [Fiscal Quarter] > @CQtr
      and ([External BU] = 'XR10')
      and [Year] >= '2019'
group by [FX Conversion]
       , [Scenario]
       , [Fiscal Quarter]
       , [Enterprise BU - Name]
       , [Route To Market 2]
       , Measures
       , [LoadDate]       