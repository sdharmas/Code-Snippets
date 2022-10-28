select [Fiscal Quarter]
	 , [Fiscal Week]
     , [Measures4]
     , [scenario]
     , [RoutetoMarket2]
     , [Type2]
     , sum([Value]) as ARR
from [dbo].[TM1_Revenue_Planning_SubscriptionsFinal]
--where [Measures3] IN ( 'Beginning', 'Net New' )
where [Measures4] IN ( 'Ending' )
      and [FX Conversion] = 'USD Current Plan Rate'
      and ([Scenario] = '2022 Plan')
      and ([RoutetoMarket2] = 'SMB & Consumer')
      and [Type2] = 'Total ARR'
GROUP BY [Fiscal Quarter]
	   , [Fiscal Week]
       , [Measures4]
       , [scenario]
       , [RoutetoMarket2]
       , [Type2]
--, [Measures4]
--, [Measures2]
--, [measures1]
order by [Measures4]
	   , [Fiscal Quarter]
	   , [Fiscal Week]
