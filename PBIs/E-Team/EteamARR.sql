-- drop table if exists #WEEK
-- drop table if exists #ARR

-- select TM1_Fiscal_WeekinYear - 1 as Current_FiscalWeek
-- into #WEEK
-- from [dbo].[Date_FiscalDateLookup] Cal
-- where DayOfCalendarDate = convert(date, getdate())

declare @CQtr varchar(10)
declare @CY varchar(10)
declare @PQtr varchar(10)

set @CQtr = '2023 Q1'
set @CY = '2023'

if right(@CQtr, 1) = 1
    -- Get Q4 of prior quarter
    set @PQtr = concat(@CY - 1, ' ', 'Q4')
else
    set @PQtr = concat(@CY, ' Q', right(@CQtr, 1) - 1)

/*   Prior YEAR */
select [FX Conversion]
     , [Scenario]
     , [Market Segment]
     , [Ind vs Team vs Ent]
     , [Enterprise BU - Name]
     , [Fiscal Week]
     , [LoadDate]
     , [Current_FiscalWeek]
     , [Measures2]
     , [Measures3]
     , [RoutetoMarket2]
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
       end                      as RTM2
     , [Type2]
     , [Fiscal Quarter]
     , [Geo]
     , [Current Quarter]
     , [FiscalWeekNum]
     , internal_offering_custom0
     , sum([Value])             as ValueAdj
-- into #ARR
from [FINANCE_SYSTEMS].[dbo].[vw_TM1_Subs_Dash]
where [Fiscal Quarter] = @PQtr
      and [Scenario] = ('Actuals')
      and
      (
          Measures3 = 'Beginning'
          or Measures3 = 'Net New'
      )
      and [FX Conversion] = 'USD Current Plan Rate'
      and [Type2] = 'Total ARR'
group by [FX Conversion]
       , [Scenario]
       , [Market Segment]
       , [Ind vs Team vs Ent]
       , [Enterprise BU - Name]
       , [Fiscal Week]
       , [LoadDate]
       , [Current_FiscalWeek]
       , [Measures2]
       , [Measures3]
       , [RoutetoMarket2]
       , [Type2]
       , [Fiscal Quarter]
       , [Geo]
       , [Current Quarter]
       , [FiscalWeekNum]
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

/*   Prior Quarter */
select [FX Conversion]
     , [Scenario]
     , [Market Segment]
     , [Ind vs Team vs Ent]
     , [Enterprise BU - Name]
     , [Fiscal Week]
     , [LoadDate]
     , [Current_FiscalWeek]
     , [Measures2]
     , [Measures3]
     , [RoutetoMarket2]
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
       end                      as RTM2
     , [Type2]
     , [Fiscal Quarter]
     , [Geo]
     , [Current Quarter]
     , [FiscalWeekNum]
     , internal_offering_custom0
     , sum([Value])             as ValueAdj
-- into #ARR
from [FINANCE_SYSTEMS].[dbo].[vw_TM1_Subs_Dash]
where [Fiscal Year] = @CY - 1
      and [Fiscal Quarter] <= concat(left(@CQtr, 4) - 1, ' ', right(@CQtr, 2))
      and [Scenario] = ('Actuals - FY22 Segmentation')
      and
      (
          Measures3 = 'Beginning'
          or Measures3 = 'Net New'
      )
      and [FX Conversion] = 'USD Current Plan Rate'
      and [Type2] = 'Total ARR'
group by [FX Conversion]
       , [Scenario]
       , [Market Segment]
       , [Ind vs Team vs Ent]
       , [Enterprise BU - Name]
       , [Fiscal Week]
       , [LoadDate]
       , [Current_FiscalWeek]
       , [Measures2]
       , [Measures3]
       , [RoutetoMarket2]
       , [Type2]
       , [Fiscal Quarter]
       , [Geo]
       , [Current Quarter]
       , [FiscalWeekNum]
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

/*   Current YEAR */
select [FX Conversion]
     , [Scenario]
     , [Market Segment]
     , [Ind vs Team vs Ent]
     , [Enterprise BU - Name]
     , [Fiscal Week]
     , [LoadDate]
     , [Current_FiscalWeek]
     , [Measures2]
     , [Measures3]
     , [RoutetoMarket2]
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
       end                      as RTM2
     , [Type2]
     , [Fiscal Quarter]
     , [Geo]
     , [Current Quarter]
     , [FiscalWeekNum]
     , internal_offering_custom0
     , sum(   case
                  when
                  (
                      scenario = 'Actuals'
                      and RoutetoMarket2 = 'All Enterprise'
                      and [Fiscal Quarter] = @CQtr
                  ) then
                      0
                  else
                      [Value]
              end
          )                     as ValueAdj
-- into #ARR
from [FINANCE_SYSTEMS].[dbo].[vw_TM1_Subs_Dash]
where [Fiscal Year] = @CY
      and [Scenario] in ( '2023 Plan', 'Actuals', 'OL - Previous', 'Outlook - Current' )
      and
      (
          Measures3 = 'Beginning'
          or Measures3 = 'Net New'
      )
      and [FX Conversion] = 'USD Current Plan Rate'
      and [Type2] = 'Total ARR'
group by [FX Conversion]
       , [Scenario]
       , [Market Segment]
       , [Ind vs Team vs Ent]
       , [Enterprise BU - Name]
       , [Fiscal Week]
       , [LoadDate]
       , [Current_FiscalWeek]
       , [Measures2]
       , [Measures3]
       , [RoutetoMarket2]
       , [Type2]
       , [Fiscal Quarter]
       , [Geo]
       , [Current Quarter]
       , [FiscalWeekNum]
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


-- alter table #ARR add Current_FiscalWeek varchar(20)

-- update #ARR
-- set Current_FiscalWeek =
--     (
--         select distinct Current_FiscalWeek from #WEEK
--     )

-- select *
-- from #ARR

