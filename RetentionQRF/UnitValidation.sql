select Scenario
     , [Fiscal Quarter]
     , LoadDate
     , format(sum(Value), 'N0') units
from TM1_Revenue_Planning_SubscriptionsFinal
where Scenario like '%QRF - Current%'
      and Type2 = 'Total Units'
      and Measures2 = 'Attrition'
group by Scenario
       , [Fiscal Quarter]
       , LoadDate
order by Scenario
       , [Fiscal Quarter]


select distinct
       scenario
     , Scenario_Desc
     , type2
     , LoadDate
from TM1_Revenue_Planning_SubscriptionsFinal
where Scenario like '%QRF - Current%'

select distinct
       scenario
from [dbo].[TM1_Revenue_Planning_SubscriptionsFinal]
order by scenario