select Scenario
     , [Fiscal Quarter]
     , LoadDate
     , format(sum("Value"), 'N0') as "Value"
from TM1_Revenue_Planning_SubscriptionsFinal
where Periodicity = 'Value'
      and Scenario = 'zAH Backup02'
      and Measures = 'Gross New (Sell In)'
      and Product1 != 'Stock Credit Pack'
      and Product1 != 'Perpetual'
      and Offerings not like '%Perpetual%'
      and
      (
          [Route to Market - Subscription] = 'Phone'
          or [Route to Market - Subscription] like '%Web%'
      )
      and Type2 = 'Total Units'
      and [Fiscal Quarter] > '2021 Q4'
group by "Scenario"
       , [Fiscal Quarter]
       , LoadDate
order by [Fiscal Quarter]