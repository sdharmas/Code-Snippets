select Scenario
     , [Fiscal Quarter]
     , LoadDate
     , format(sum(Value), 'N0') units
from TM1_Revenue_Planning_SubscriptionsFinal
where Scenario like '%zAH Backup05%'
      and Type2 = 'Total Units'
group by Scenario
       , [Fiscal Quarter]
       , LoadDate
order by Scenario
       , [Fiscal Quarter]


select distinct
       scenario
     , type2
     , LoadDate
from TM1_Revenue_Planning_SubscriptionsFinal
where Scenario like '%zAH Backup05%'