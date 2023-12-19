-- drop table if exists #WEEK
-- drop table if exists #ARR

-- select TM1_Fiscal_WeekinYear - 1 as Current_FiscalWeek
-- into #WEEK
-- from [dbo].[Date_FiscalDateLookup] Cal
-- where DayOfCalendarDate = convert(date, getdate())

declare @CQtr varchar(10) = '2024 Q1'
declare @CY varchar(10) = left(@CQtr, 4)
declare @PQtr varchar(10)


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
     , [FINSYS_LoadDate]                as LoadDate
     , [Current_FiscalWeek]
     , [Measures2]
     , [Measures3]
     , [RoutetoMarket2]
     , [Route to Market - Subscription] as RTM3
     , [Type2]
     , [Fiscal Quarter]
     , [Geo]
     , [Current Quarter]
     , [FiscalWeekNum]
     , internal_offering_custom0
     , sum([Value])                     as ValueAdj
-- into #ARR
from [FINANCE_SYSTEMS].[dbo].[vw_TM1_Subs_Dash]
where (
          /* Current Year Actuals */
          (
              [Fiscal Year] = @CY
              and [Fiscal Quarter] <= @CQtr
              and [Scenario] = ('Actuals')
          )
          /* Prior Year Actuals */
          or
          (
              [Fiscal Year] = @CY - 1
              and [Fiscal Quarter] <= concat(left(@CQtr, 4) - 1, ' ', right(@CQtr, 2))
              and [Scenario] = ('Actuals')
          )
          /* Current Year Forecast scenarios */
          or [Fiscal Year] = @CY
             and [Scenario] in ( '2024 Plan', 'OL - Previous', 'Outlook - Current', 'Q3 QRF 2024', 'Q4 QRF 2024'
                               , 'Dashboard QRF', 'QRF - Current'
                               )
      )
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
       , [FINSYS_LoadDate]
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
       , [Route to Market - Subscription]

-- alter table #ARR add Current_FiscalWeek varchar(20)

-- update #ARR
-- set Current_FiscalWeek =
--     (
--         select distinct Current_FiscalWeek from #WEEK
--     )

-- select *
-- from #ARR

