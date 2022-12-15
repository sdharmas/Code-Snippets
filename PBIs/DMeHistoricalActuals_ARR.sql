-- Remember to change the QRF scenario at the bottom, and also Plan (do we need it?)

declare @CQtr varchar(10)

set @CQtr = '2022 Q4'
-- (
--     select distinct [Current Quarter] from vw_TM1_Subs_Dash
-- )


-- // Actuals prior to 2022-Q3, pull all FX variants from 'Actuals - FY22 Segmentation' scenario

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
          [Fiscal Year] in ( '2020', '2021' )
          or [Fiscal Quarter] in ( '2022 Q1', '2022 Q2' )
      )
      and [Scenario] in ( 'Actuals - FY22 Segmentation' )
      and
      (
          Measures3 = 'Beginning'
          or Measures3 = 'Net New'
      )
      and [FX Conversion] in ( 'USD Current Plan Rate', 'USD Current QRF Rate', 'USD as Reported' )
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

-- // Actuals before Current Quarter on or after 2022-Q3, pull all FX versions from 'Actuals' scenario 

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
          [Fiscal Quarter] >= '2022 Q3'
          and [Fiscal Quarter] < [Current Quarter]
      )
      and [Scenario] in ( 'Actuals' )
      and
      (
          Measures3 = 'Beginning'
          or Measures3 = 'Net New'
      )
      and [FX Conversion] in ( 'USD Current Plan Rate', 'USD Current QRF Rate', 'USD as Reported' )
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


-- // Outlook-Current for Current Quarter or just closed quarter, pull only 'USD Current Plan Rate' and 'USD Current QRF Rate'

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
      and [FX Conversion] in ( 'USD Current Plan Rate', 'USD Current QRF Rate' )
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

-- // QRF for Current Quarter or just closed quarter, pull only 'USD Current Plan Rate' and 'USD Current QRF Rate'

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
      and [Scenario] = ('Q4 QRF 2022')
      and
      (
          Measures3 = 'Beginning'
          or Measures3 = 'Net New'
      )
      and [FX Conversion] in ( 'USD Current Plan Rate', 'USD Current QRF Rate' )
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

-- // Temp only to pull Plan
-- // QRF for Current Quarter, pull only 'USD Current Plan/QRF Rate'
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
where [Fiscal Quarter] > @CQtr
      and [Scenario] = ('QRF - Current')
      and
      (
          Measures3 = 'Beginning'
          or Measures3 = 'Net New'
      )
      and [FX Conversion] in ( 'USD Current Plan Rate', 'USD Current QRF Rate' )
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
-- // Temp only to pull Plan
-- // QBR Plan for Current Quarter, pull only 'USD Current Plan/QRF Rate'
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
where [Fiscal Quarter] > @CQtr
      and [Scenario] = ('FY23 High Submission')
      and
      (
          Measures3 = 'Beginning'
          or Measures3 = 'Net New'
      )
      and [FX Conversion] in ( 'USD Current Plan Rate', 'USD Current QRF Rate' )
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
