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
      --   and [Year] in ( '2021', '2022' )
      and [Fiscal Quarter] = @CQtr
      and [Route To Market] = 'Subscription'
group by [Fiscal Quarter]
       , Scenario
union all
select [Fiscal Quarter]
     , Scenario
     , 'Perpetual'                as Dimension
     , format(sum([Value]), 'N0') Revenue
from TM1_Revenue_Planning_Consolidated_Final
where Scenario = 'Actuals'
      and [FX Conversion] = 'USD'
      and [Measures] = 'Adjusted Net New Revenue'
      and ([External BU] = 'XR10')
      --   and [Year] in ( '2021', '2022' )
      and [Fiscal Quarter] = @CQtr
      and [Route To Market] = 'Perpetual'
group by [Fiscal Quarter]
       , Scenario
union all
select [Fiscal Quarter]
     , Scenario
     , 'M&S'                      as Dimension
     , format(sum([Value]), 'N0') Revenue
from TM1_Revenue_Planning_Consolidated_Final
where Scenario = 'Actuals'
      and [FX Conversion] = 'USD'
      and [Measures] = 'Adjusted Net New Revenue'
      and ([External BU] = 'XR10')
      --   and [Year] in ( '2021', '2022' )
      and [Fiscal Quarter] = @CQtr
      and [Route To Market] = 'M&S'
group by [Fiscal Quarter]
       , Scenario
union all
select [Fiscal Quarter]
     , Scenario
     , 'OEM'                      as Dimension
     , format(sum([Value]), 'N0') Revenue
from TM1_Revenue_Planning_Consolidated_Final
where Scenario = 'Actuals'
      and [FX Conversion] = 'USD'
      and [Measures] = 'Adjusted Net New Revenue'
      and ([External BU] = 'XR10')
      --   and [Year] in ( '2021', '2022' )
      and [Fiscal Quarter] = @CQtr
      and [Route To Market] = 'OEM'
group by [Fiscal Quarter]
       , Scenario




