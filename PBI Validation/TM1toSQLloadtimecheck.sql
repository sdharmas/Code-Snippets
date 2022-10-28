select [Scenario]
     , max(LoadDate) loadtime
from [dbo].[TM1_Revenue_Planning_SubscriptionsFinal]
where   [Scenario] in ( 'Outlook - Current',  'Actuals')
group by [Scenario]

