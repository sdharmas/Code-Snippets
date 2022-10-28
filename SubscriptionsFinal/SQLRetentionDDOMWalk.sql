with MainTbl
as (select
        --[Periodicity]
        -- ,[FX Conversion]
        [Scenario]
      , [RoutetoMarket1]
      , [Route to Market - Subscription]
      , [Product]
      , [App Names]
      , [Ind vs Team vs Ent]
      , [Type2]
      --,[Type1]
      , [EntitlementPeriod2]
      --,[Entitlement Period]
      , [Offerings2]
      , [Offerings]
      , [Measures4]
      , [Measures3]
      , [Measures2]
      , [Measures1]
      , [RegularVsPromo1]
      --,[Regular vs Promo]
      , [Market Area - Name]
      --,[Fiscal Year]
      , [Fiscal Quarter]
      --,[Fiscal Period]
      , [Fiscal Week]
      , sum([Value])                    as Value
      , [LoadDate]
    --,[Measures]
    --,[Cloud Types]
    --,[Profit Center]
    --,[AppNames1]
    --,[CloudTypes1]
    --,[EntitlementPeriod1]
    --,[IndivdualVsTeam1]
    --,[Offerings1]
    --,[Offerings3]
    --,[Product1]
    --,[Product2]
    --,[Type]
    --,[Type3]
    --,[Region]
    --,[Region - Name]
    --,[Geo]
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
    from [FINANCE_SYSTEMS].[dbo].[TM1_Revenue_Planning_SubscriptionsFinal]
    where [FX Conversion] = 'USD'
          and ([Scenario] = 'QRF - Current')
          and ([RoutetoMarket1] <> 'Enterprise')
          and ([Measures4] = 'Ending')
          and
          (
              [Type2] = 'Total ARR'
              or [Type2] = 'Total Units'
          )
          and [Ind vs Team vs Ent] <> 'Not Assigned'
          and [Market Area - Name] not like '#'
          and [Offerings1] not like '%Perpetual%'
          and [App Names] not like '%EEA%'
          and [App Names] not like '%ELTA%'
          and [Fiscal Quarter] >= '2021 Q4'
    group by
        --[Periodicity]
        --     ,[FX Conversion]
        --     ,
        [Scenario]
      , [RoutetoMarket1]
      , [Route to Market - Subscription]
      , [Product]
      , [App Names]
      , [Ind vs Team vs Ent]
      , [Type2]
      --,[Type1]
      , [EntitlementPeriod2]
      --,[Entitlement Period]
      , [Offerings2]
      , [Offerings]
      , [Measures4]
      , [Measures3]
      , [Measures2]
      , [Measures1]
      , [RegularVsPromo1]
      --,[Regular vs Promo]
      , [Market Area - Name]
      --,[Fiscal Year]
      , [Fiscal Quarter]
      --,[Fiscal Period]
      , [Fiscal Week]
      , [LoadDate])
(select *
      , Category  = 'Beginning'
      , SortOrder = 1
 from MainTbl
 where [Measures3] like '%Beginning%')
union
(select *
      , Category  = 'Gross New (Sell In)'
      , SortOrder = 2
 from MainTbl
 where [Measures2] like '%Gross New (Sell In)%')
union
(select *
      , Category  = 'User Initiated'
      , SortOrder = 3
 from MainTbl
 where [Measures1] like '%User Initiated%')
union
(select *
      , Category  = 'Credit Card Failure'
      , SortOrder = 4
 from MainTbl
 where [Measures1] like '%Credit Card Failure%')
union
(select *
      , Category  = 'Channel Non Renewal'
      , SortOrder = 5
 from MainTbl
 where [Measures1] like '%Channel Non Renewal%')
union
(select *
      , Category  = 'Net Migrations'
      , SortOrder = 6
 from MainTbl
 where [Measures2] like '%Net Migrations%')
union
(select *
      , Category  = 'Net New'
      , SortOrder = 7
 from MainTbl
 where [Measures3] like '%Net New%')
union
(select *
      , Category  = 'Ending'
      , SortOrder = 8
 from MainTbl
 where [Measures4] like '%Ending%');




