drop table if exists #ARR

select [Scenario]
     , [FX Conversion]
     , [RoutetoMarket1]
     , [Route to Market - Subscription]
     , [Market Segment]
     , [Geo]
     , [Product]
     , [App Names]
     , [Ind vs Team vs Ent]
     , [Cloud Types]
     , [Type]
     , [Type1]
     , [Type2]
     , [EntitlementPeriod1]
     , [Offerings2]
     , [Offerings]
     , [Measures4]
     , [Measures3]
     , [Measures2]
     , [Measures1]
     , [RegularVsPromo1]
     , [Market Area - Name]
     , [Fiscal Quarter]
     , [Fiscal Week]
     , sum([Value])                    as Value
     , [LoadDate] --,[Profit Center]
--,[AppNames1]
--,[CloudTypes1]
--,[EntitlementPeriod1]
--,[IndivdualVsTeam1]
--,[Offerings1]
--,[Offerings3]
--,[Product1]
--,[Product2]
--,[Type3]
--,[Region]
--,[Region - Name]
--,[Profit Center - Name]
--,[PMBU]
--,[PMBU - Name]
--,[InternalSegment]
--,[InternalSegment - Name]
--,[Group]
--,[Group - Name]
--,[Enterprise BU]
--,[Enterprise BU - Name]
--,[External BU]
--,[External BU - Name]
--,[First_TM1_Fiscal_WeekinQtr]
into #ARR
from [FINANCE_SYSTEMS].[dbo].[TM1_Revenue_Planning_SubscriptionsFinal]
where ([Scenario] = '2023 Plan')
      and ([RoutetoMarket1] <> 'Enterprise')
      and ([RoutetoMarket1] <> 'Enterprise (VIP)')
      and ([RoutetoMarket1] <> 'Phone - Named')
      and ([RoutetoMarket1] <> 'Reseller - Named')
      and ([Measures2] = 'Attrition')
      and [Ind vs Team vs Ent] <> 'Not Assigned'
      and [Market Area - Name] not like '#'
      and
      (
          [Product] <> 'CP Default'
          and [Product] <> 'CP001'
          and [Product] <> 'CP005'
          and [Product] <> 'CP016'
          and [Product] <> 'CP040'
          and [Product] <> 'CP080'
          and [Product] <> 'CP150'
          and [Product] <> 'CP500'
          and [Product] <> 'LIC'
          and [Product] <> 'Shrink'
          and [Product] <> 'Stock On Demand'
      )
      and ([Offerings] <> 'CSMB ETLA')
      and
      (
          [App Names] <> 'EEA'
          and [App Names] <> 'ETLA'
      )
      and
      (
          [Type2] = 'Total ARR'
          or [Type2] = 'Total Units'
      )
      and ([Fiscal Quarter] in ( '2023 Q1', '2023 Q2', '2023 Q3', '2023 Q4' ))
      and [FX Conversion] = 'USD Current Plan Rate'
group by [Scenario]
       , [FX Conversion]
       , [RoutetoMarket1]
       , [Route to Market - Subscription]
       , [Market Segment]
       , [Product]
       , [App Names]
       , [Geo]
       , [Ind vs Team vs Ent]
       , [Cloud Types]
       , [Type]
       , [Type1]
       , [Type2]
       , [EntitlementPeriod1]
       , [Offerings2]
       , [Offerings]
       , [Measures4]
       , [Measures3]
       , [Measures2]
       , [Measures1]
       , [RegularVsPromo1]
       , [Market Area - Name]
       , [Fiscal Quarter]
       , [Fiscal Week]
       , [LoadDate]

--  select [Scenario]
--          , [FX Conversion]
--     --   , RoutetoMarket1
--          , [Fiscal Quarter]
--          , Measures2
--          , Measures1
--          , [LoadDate]
--          , format(sum([Value]),'N0') as Value
--     from #ARR

--     where Type2 = 'Total ARR'
--     group by [Scenario]
--            , [FX Conversion]
--             -- , RoutetoMarket1
--            , Measures2
--                     , Measures1
--            , [Fiscal Quarter]
--            , [LoadDate]
--     order by [Fiscal Quarter]       


select [FX Conversion]
     , scenario
     --   , RoutetoMarket1
     --  , [Fiscal Quarter]
     , Measures2
     , Measures1
     , [LoadDate]
     , format(sum([2023 Q1]), 'N0') as Q1
     , format(sum([2023 Q2]), 'N0') as Q2
     , format(sum([2023 Q3]), 'N0') as Q3
     , format(sum([2023 Q4]), 'N0') as Q4
from #ARR
    pivot
    (
        sum([Value])
        for #ARR.[Fiscal Quarter] in ([2023 Q1], [2023 Q2], [2023 Q3], [2023 Q4])
    ) as QuarterPivot
group by [FX Conversion]
       , scenario
       , [Measures2]
       , Measures1
       , LoadDate
--    , RoutetoMarket1
