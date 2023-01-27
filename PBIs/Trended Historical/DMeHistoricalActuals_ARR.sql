-- Remember to change the QRF scenario at the bottom, and also Plan (do we need it?)

declare @CQtr varchar(10)
declare @CY varchar(10)

set @CQtr = '2023 Q1'
set @CY = '2023'

-- (
--     select distinct [Current Quarter] from vw_TM1_Subs_Dash
-- )

-- // Actuals prior to 2019, pull all FX variants from 'Actuals' scenario

select [Scenario]
     , [FX Conversion]
     , [Market Area - Name]
     , [Ind vs Team vs Ent]
     , [Enterprise BU - Name]
     , [Fiscal Week]
     , [LoadDate]
     , [Measures2]
     , [Measures3]
     , [RoutetoMarket2]
     , [Fiscal Quarter]
     , [Current Quarter]
     , internal_offering_custom0
     , case
           when [Route to Market - Subscription] = 'Enterprise' then
               'ETLA'
           when [Route to Market - Subscription] in ( 'Phone - Named', 'Reseller - Named' ) then
               'VIP'
           when [Route to Market - Subscription] like '%Web%' then
               'Web'
           when [Route to Market - Subscription] = 'Phone' then
               'Phones'
           when [Route to Market - Subscription] = 'App Store' then
               'App Store'
           else
               'Channel'
       end          as RTM1
     , sum([Value]) as ValueAdj
from [FINANCE_SYSTEMS].[dbo].[vw_TM1_Subs_Dash]
where ([Fiscal Year] between '2016' and '2018' )
      and [Scenario] = ( 'Actuals' )
      and
      (
          Measures3 = 'Beginning'
          or Measures3 = 'Net New'
      )
      and [FX Conversion] in ( 'USD Current Plan Rate',  'USD as Reported' )
      and [Type2] = 'Total ARR'
group by [Scenario]
       , [FX Conversion]
       , [Market Area - Name]
       , [Ind vs Team vs Ent]
       , [Enterprise BU - Name]
       , [Fiscal Week]
       , [LoadDate]
       , [Measures2]
       , [Measures3]
       , [RoutetoMarket2]
       , [Fiscal Quarter]
       , [Current Quarter]
       , internal_offering_custom0
       , case
             when [Route to Market - Subscription] = 'Enterprise' then
                 'ETLA'
             when [Route to Market - Subscription] in ( 'Phone - Named', 'Reseller - Named' ) then
                 'VIP'
             when [Route to Market - Subscription] like '%Web%' then
                 'Web'
             when [Route to Market - Subscription] = 'Phone' then
                 'Phones'
             when [Route to Market - Subscription] = 'App Store' then
                 'App Store'
             else
                 'Channel'
         end
union all

-- // Actuals from 2019 to 2022, pull all FX variants from 'Actuals - Segmentation' scenario

select [Scenario]
     , [FX Conversion]
     , [Market Area - Name]
     , [Ind vs Team vs Ent]
     , [Enterprise BU - Name]
     , [Fiscal Week]
     , [LoadDate]
     , [Measures2]
     , [Measures3]
     , [RoutetoMarket2]
     , [Fiscal Quarter]
     , [Current Quarter]
     , internal_offering_custom0
     , case
           when [Route to Market - Subscription] = 'Enterprise' then
               'ETLA'
           when [Route to Market - Subscription] in ( 'Phone - Named', 'Reseller - Named' ) then
               'VIP'
           when [Route to Market - Subscription] like '%Web%' then
               'Web'
           when [Route to Market - Subscription] = 'Phone' then
               'Phones'
           when [Route to Market - Subscription] = 'App Store' then
               'App Store'
           else
               'Channel'
       end          as RTM1
     , sum([Value]) as ValueAdj
from [FINANCE_SYSTEMS].[dbo].[vw_TM1_Subs_Dash]
where (
          [Fiscal Year] between '2019' and '2022'
      )
      and [Scenario] in ( 'Actuals - Segmentation' )
      and
      (
          Measures3 = 'Beginning'
          or Measures3 = 'Net New'
      )
      and [FX Conversion] in ( 'USD Current Plan Rate',  'USD as Reported' )
      and [Type2] = 'Total ARR'
group by [Scenario]
       , [FX Conversion]
       , [Market Area - Name]
       , [Ind vs Team vs Ent]
       , [Enterprise BU - Name]
       , [Fiscal Week]
       , [LoadDate]
       , [Measures2]
       , [Measures3]
       , [RoutetoMarket2]
       , [Fiscal Quarter]
       , [Current Quarter]
       , internal_offering_custom0
       , case
             when [Route to Market - Subscription] = 'Enterprise' then
                 'ETLA'
             when [Route to Market - Subscription] in ( 'Phone - Named', 'Reseller - Named' ) then
                 'VIP'
             when [Route to Market - Subscription] like '%Web%' then
                 'Web'
             when [Route to Market - Subscription] = 'Phone' then
                 'Phones'
             when [Route to Market - Subscription] = 'App Store' then
                 'App Store'
             else
                 'Channel'
         end
union all


-- // Outlook-Current for Current Quarter or just closed quarter, pull only 'USD Current Plan Rate' 

select [Scenario]
     , [FX Conversion]
     , [Market Area - Name]
     , [Ind vs Team vs Ent]
     , [Enterprise BU - Name]
     , [Fiscal Week]
     , [LoadDate]
     , [Measures2]
     , [Measures3]
     , [RoutetoMarket2]
     , [Fiscal Quarter]
     , [Current Quarter]
     , internal_offering_custom0
     , case
           when [Route to Market - Subscription] = 'Enterprise' then
               'ETLA'
           when [Route to Market - Subscription] in ( 'Phone - Named', 'Reseller - Named' ) then
               'VIP'
           when [Route to Market - Subscription] like '%Web%' then
               'Web'
           when [Route to Market - Subscription] = 'Phone' then
               'Phones'
           when [Route to Market - Subscription] = 'App Store' then
               'App Store'
           else
               'Channel'
       end          as RTM1
     , sum([Value]) as ValueAdj
from [FINANCE_SYSTEMS].[dbo].[vw_TM1_Subs_Dash]
where [Fiscal Quarter] = @CQtr
      and [Scenario] = ('Outlook - Current')
      and
      (
          Measures3 = 'Beginning'
          or Measures3 = 'Net New'
      )
      and [FX Conversion] in ( 'USD Current Plan Rate' )
      and [Type2] = 'Total ARR'
group by [Scenario]
       , [FX Conversion]
       , [Market Area - Name]
       , [Ind vs Team vs Ent]
       , [Enterprise BU - Name]
       , [Fiscal Week]
       , [LoadDate]
       , [Measures2]
       , [Measures3]
       , [RoutetoMarket2]
       , [Fiscal Quarter]
       , [Current Quarter]
       , internal_offering_custom0
       , case
             when [Route to Market - Subscription] = 'Enterprise' then
                 'ETLA'
             when [Route to Market - Subscription] in ( 'Phone - Named', 'Reseller - Named' ) then
                 'VIP'
             when [Route to Market - Subscription] like '%Web%' then
                 'Web'
             when [Route to Market - Subscription] = 'Phone' then
                 'Phones'
             when [Route to Market - Subscription] = 'App Store' then
                 'App Store'
             else
                 'Channel'
         end
union all

-- // Outlook-Current for Current Quarter or just closed quarter, fake 'USD Current Plan Rate' to 'USD as reported' 

select [Scenario]
     , 'USD as Reported' 'FX Conversion'
     , [Market Area - Name]
     , [Ind vs Team vs Ent]
     , [Enterprise BU - Name]
     , [Fiscal Week]
     , [LoadDate]
     , [Measures2]
     , [Measures3]
     , [RoutetoMarket2]
     , [Fiscal Quarter]
     , [Current Quarter]
     , internal_offering_custom0
     , case
           when [Route to Market - Subscription] = 'Enterprise' then
               'ETLA'
           when [Route to Market - Subscription] in ( 'Phone - Named', 'Reseller - Named' ) then
               'VIP'
           when [Route to Market - Subscription] like '%Web%' then
               'Web'
           when [Route to Market - Subscription] = 'Phone' then
               'Phones'
           when [Route to Market - Subscription] = 'App Store' then
               'App Store'
           else
               'Channel'
       end          as RTM1
     , sum([Value]) as ValueAdj
from [FINANCE_SYSTEMS].[dbo].[vw_TM1_Subs_Dash]
where [Fiscal Quarter] = @CQtr
      and [Scenario] = ('Outlook - Current')
      and
      (
          Measures3 = 'Beginning'
          or Measures3 = 'Net New'
      )
      and [FX Conversion] in ( 'USD Current Plan Rate' )
      and [Type2] = 'Total ARR'
group by [Scenario]
       , [FX Conversion]
       , [Market Area - Name]
       , [Ind vs Team vs Ent]
       , [Enterprise BU - Name]
       , [Fiscal Week]
       , [LoadDate]
       , [Measures2]
       , [Measures3]
       , [RoutetoMarket2]
       , [Fiscal Quarter]
       , [Current Quarter]
       , internal_offering_custom0
       , case
             when [Route to Market - Subscription] = 'Enterprise' then
                 'ETLA'
             when [Route to Market - Subscription] in ( 'Phone - Named', 'Reseller - Named' ) then
                 'VIP'
             when [Route to Market - Subscription] like '%Web%' then
                 'Web'
             when [Route to Market - Subscription] = 'Phone' then
                 'Phones'
             when [Route to Market - Subscription] = 'App Store' then
                 'App Store'
             else
                 'Channel'
         end
union all

-- // QRF for Current Quarter or just closed quarter, pull only 'USD Current Plan Rate'

select [Scenario]
     , [FX Conversion]
     , [Market Area - Name]
     , [Ind vs Team vs Ent]
     , [Enterprise BU - Name]
     , [Fiscal Week]
     , [LoadDate]
     , [Measures2]
     , [Measures3]
     , [RoutetoMarket2]
     , [Fiscal Quarter]
     , [Current Quarter]
     , internal_offering_custom0
     , case
           when [Route to Market - Subscription] = 'Enterprise' then
               'ETLA'
           when [Route to Market - Subscription] in ( 'Phone - Named', 'Reseller - Named' ) then
               'VIP'
           when [Route to Market - Subscription] like '%Web%' then
               'Web'
           when [Route to Market - Subscription] = 'Phone' then
               'Phones'
           when [Route to Market - Subscription] = 'App Store' then
               'App Store'
           else
               'Channel'
       end          as RTM1
     , sum([Value]) as ValueAdj
from [FINANCE_SYSTEMS].[dbo].[vw_TM1_Subs_Dash]
where [Fiscal Year] = @CY
      and [Scenario] = ('2023 Plan')
      and
      (
          Measures3 = 'Beginning'
          or Measures3 = 'Net New'
      )
      and [FX Conversion] in ( 'USD Current Plan Rate' )
      and [Type2] = 'Total ARR'
group by [Scenario]
       , [FX Conversion]
       , [Market Area - Name]
       , [Ind vs Team vs Ent]
       , [Enterprise BU - Name]
       , [Fiscal Week]
       , [LoadDate]
       , [Measures2]
       , [Measures3]
       , [RoutetoMarket2]
       , [Fiscal Quarter]
       , [Current Quarter]
       , internal_offering_custom0
       , case
             when [Route to Market - Subscription] = 'Enterprise' then
                 'ETLA'
             when [Route to Market - Subscription] in ( 'Phone - Named', 'Reseller - Named' ) then
                 'VIP'
             when [Route to Market - Subscription] like '%Web%' then
                 'Web'
             when [Route to Market - Subscription] = 'Phone' then
                 'Phones'
             when [Route to Market - Subscription] = 'App Store' then
                 'App Store'
             else
                 'Channel'
         end

-- // QRF for Current Quarter or just closed quarter, fake 'USD Current Plan Rate' to 'USD as reported' 

union ALL
select [Scenario]
     , 'USD as Reported' 'FX Conversion'
     , [Market Area - Name]
     , [Ind vs Team vs Ent]
     , [Enterprise BU - Name]
     , [Fiscal Week]
     , [LoadDate]
     , [Measures2]
     , [Measures3]
     , [RoutetoMarket2]
     , [Fiscal Quarter]
     , [Current Quarter]
     , internal_offering_custom0
     , case
           when [Route to Market - Subscription] = 'Enterprise' then
               'ETLA'
           when [Route to Market - Subscription] in ( 'Phone - Named', 'Reseller - Named' ) then
               'VIP'
           when [Route to Market - Subscription] like '%Web%' then
               'Web'
           when [Route to Market - Subscription] = 'Phone' then
               'Phones'
           when [Route to Market - Subscription] = 'App Store' then
               'App Store'
           else
               'Channel'
       end          as RTM1
     , sum([Value]) as ValueAdj
from [FINANCE_SYSTEMS].[dbo].[vw_TM1_Subs_Dash]
where [Fiscal Year] = @CY
      and [Scenario] = ('2023 Plan')
      and
      (
          Measures3 = 'Beginning'
          or Measures3 = 'Net New'
      )
      and [FX Conversion] in ( 'USD Current Plan Rate' )
      and [Type2] = 'Total ARR'
group by [Scenario]
       , [FX Conversion]
       , [Market Area - Name]
       , [Ind vs Team vs Ent]
       , [Enterprise BU - Name]
       , [Fiscal Week]
       , [LoadDate]
       , [Measures2]
       , [Measures3]
       , [RoutetoMarket2]
       , [Fiscal Quarter]
       , [Current Quarter]
       , internal_offering_custom0
       , case
             when [Route to Market - Subscription] = 'Enterprise' then
                 'ETLA'
             when [Route to Market - Subscription] in ( 'Phone - Named', 'Reseller - Named' ) then
                 'VIP'
             when [Route to Market - Subscription] like '%Web%' then
                 'Web'
             when [Route to Market - Subscription] = 'Phone' then
                 'Phones'
             when [Route to Market - Subscription] = 'App Store' then
                 'App Store'
             else
                 'Channel'
         end

-- union all

-- // Temp only to pull Plan
-- // QRF for Current Quarter, pull only 'USD Current Plan/QRF Rate'

-- select [Scenario]
--      , [FX Conversion]
--      , [Market Area - Name]
--      , [Ind vs Team vs Ent]
--      , [Enterprise BU - Name]
--      , [Fiscal Week]
--      , [LoadDate]
--      , [Measures2]
--      , [Measures3]
--      , [RoutetoMarket2]
--      , [Fiscal Quarter]
--      , [Current Quarter]
--      , internal_offering_custom0
--      , case
--            when [Route to Market - Subscription] = 'Enterprise' then
--                'ETLA'
--            when [Route to Market - Subscription] in ( 'Phone - Named', 'Reseller - Named' ) then
--                'VIP'
--            when [Route to Market - Subscription] like '%Web%' then
--                'Web'
--            when [Route to Market - Subscription] = 'Phone' then
--                'Phones'
--            when [Route to Market - Subscription] = 'App Store' then
--                'App Store'
--            else
--                'Channel'
--        end          as RTM1
--      , sum([Value]) as ValueAdj
-- from [FINANCE_SYSTEMS].[dbo].[vw_TM1_Subs_Dash]
-- where [Fiscal Quarter] > @CQtr
--       and [Scenario] = ('QRF - Current')
--       and
--       (
--           Measures3 = 'Beginning'
--           or Measures3 = 'Net New'
--       )
--       and [FX Conversion] in ( 'USD Current Plan Rate', 'USD Current QRF Rate' )
--       and [Type2] = 'Total ARR'
-- group by [Scenario]
--        , [FX Conversion]
--        , [Market Area - Name]
--        , [Ind vs Team vs Ent]
--        , [Enterprise BU - Name]
--        , [Fiscal Week]
--        , [LoadDate]
--        , [Measures2]
--        , [Measures3]
--        , [RoutetoMarket2]
--        , [Fiscal Quarter]
--        , [Current Quarter]
--        , internal_offering_custom0
--        , case
--              when [Route to Market - Subscription] = 'Enterprise' then
--                  'ETLA'
--              when [Route to Market - Subscription] in ( 'Phone - Named', 'Reseller - Named' ) then
--                  'VIP'
--              when [Route to Market - Subscription] like '%Web%' then
--                  'Web'
--              when [Route to Market - Subscription] = 'Phone' then
--                  'Phones'
--              when [Route to Market - Subscription] = 'App Store' then
--                  'App Store'
--              else
--                  'Channel'
--          end
