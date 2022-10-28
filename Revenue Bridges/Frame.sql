declare @CQtr varchar(10)

set @CQtr = '2022 Q2'


select [Fiscal Quarter]
     , Scenario
     , 'Subscription'             as Dimension
     , format(sum([Value]), 'N0') Revenue
from TM1_Revenue_Planning_Consolidated_Final
where Scenario = 'Actuals'
      and [FX Conversion] = 'USD'
      and [Measures] = 'Adjusted Net New Revenue'
      and ([External BU] = 'XR10')
      and [Fiscal Quarter] = @CQtr
      and [Profit Center] = '1790'
      and [Route To Market 2] = 'SMB & Consumer'
group by [Fiscal Quarter]
       , Scenario
