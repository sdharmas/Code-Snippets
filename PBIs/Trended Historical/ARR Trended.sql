-- Remember to change variables before the dotted line section

declare @CQtr varchar(10) = '2023 Q4'

declare @QRFsnap varchar(50) = 'Dashboard QRF'

declare @QRF varchar(50) = 'Q4 QRF 2023'

declare @Plan varchar(50) = '2023 Plan'

------------------------------------------------------------------------------------------
declare @CY varchar(10) = left(@CQtr, 4)
declare @lastdayofQtr varchar(50) =
        (
            select distinct
                   [Last Day of Fiscal Quarter]
            from [dbo].[Date_FiscalDateLookup]
            where [TM1_Fiscal Qtr/Year] = @CQtr
        )
declare @today varchar(50) =
        (
            select format(getdate(), 'yyyy-MM-dd')
        )
-- declare @CFQtoday varchar(50) =
--         (
--             select [TM1_Fiscal Qtr/Year]
--             from Date_FiscalDateLookup
--             where DayOfCalendarDate = @today
--         )
-- declare @RFQtoday varchar(50) =
--         (
--             select [Relative Fiscal Quarter]
--             from Date_FiscalDateLookup
--             where DayOfCalendarDate = @today
--         )
-- declare @RFQQuarterEnd varchar(50) =
--         (
--             select [Relative Fiscal Quarter]
--             from Date_FiscalDateLookup
--             where DayOfCalendarDate = @lastdayofQtr
--         )
-- declare @RFQ varchar(50) =
--         (
--             select case when @CFQtoday > @CQtr then @RFQQuarterEnd else @RFQtoday end
--         )
declare @RdayQuarterEnd varchar(50) =
        (
            select [Relative Day]
            from Date_FiscalDateLookup
            where DayOfCalendarDate = @lastdayofQtr
        )
declare @Rday varchar(50) =
        (
            select case when @today > @lastdayofQtr then @RdayQuarterEnd else 0 end
        )
-- select @today          today
--  , @CFQtoday       'CFQ (based on today)'
--     , @CQtr           'Current Qtr (hardcoded)'
--  , @RFQtoday       'RFQ (based on today)'
--     , @lastdayofQtr   'last day of Qtr'
--  , @RFQQuarterEnd  'RFQ (QE) based on last day of Qtr'
--  , @RFQ            'RFQ (cond: RFQ [today] or [QE])'
--     , @RdayQuarterEnd 'RdayQE (at Quarter End)'
--     , @Rday           'Rday (cond: RdayQE or 0)'

select @CQtr                            as 'Current Quarter'
     , @Rday                            as 'Relative Day at Quarter End'
     , internal_offering_custom0
     , [Scenario]
     , [Fiscal Quarter]
     , case
           when @Rday < 0 then
               'QTD' -- Quarter has closed so all weeks are QTD
           when FiscalWeekNum < CW.WkNum
                and [Route to Market - Subscription] <> 'Enterprise' then
               'QTD'
           else
               'QTG'
       end                              as [QTD/QTG]
     , [Market Segment]
     , Offerings
     , [App Names]
     , [FX Conversion]
     , [Market Area - Name]
     , [Ind vs Team vs Ent]
     , [Enterprise BU - Name]
     , [RoutetoMarket2]
     , [Route to Market - Subscription] as RTM3
     , [Measures2]
     , [Measures3]
     , [Type2]
     , case
           when [Type2] = 'Total ARR' then
               sum([Value]) / 1e6
           when [Type2] = 'Total Units' then
               sum([Value]) / 1e3
       end                              as ValueAdj
     , FINSYS_LoadDate                  as LoadDate
from [FINANCE_SYSTEMS].[dbo].[vw_TM1_Subs_Dash] A
    left join
    (
        select right(TM1_Fiscal_WeekinQtr, 2) WkNum
        from [dbo].[Date_FiscalDateLookup]
        where [Relative Day] = @Rday
    )                                           CW
        on 1 = 1
where --[Fiscal Quarter] = '2023 Q3' and
    (
        (
            [Fiscal Year] >= '2019'
            and [Fiscal Year] <= '2022'
            and [Scenario] = ('Actuals - Segmentation')
        )
        or
        (
            [Fiscal Year] >= '2023'
            and [Scenario] = ('Actuals')
        )
        or
        (
            [Fiscal Quarter] = @CQtr
            and [Scenario] in ( 'Outlook - Current', 'OL - Previous' )
        ) --- Outlook - Current from Current Fiscal Quarter
        or
        (
            [Fiscal Year] = @CY
            and [Scenario] in ( @Plan, @QRF, 'Q2 QRF 2023', 'Q3 QRF 2023' )
        )
        or
        (
            [Fiscal Year] > @CY
            and
            (
                [Scenario] in ( 'DME 2024 Strat Plan Pass 2', 'Strat Plan - FY24 to FY26'
                              , 'Strat Plan v2 - FY24 to FY26'
                              )
                or Scenario like ('%DME 2024 Ops Plan Pass%')
                or Scenario in ( 'QRF - Mid', 'FY24 High Submission', 'FY24 Mid Submission' )
            )
        )
        or
        (
            [Fiscal Year] > @CY
            and [Scenario] like ('%FY24 Plan%')
        )
        or
        (
            [Fiscal Year] > @CY
            and [Scenario] in ( '2024 Plan' )
        )
        or         (
            [Fiscal Year] >= @CY
            and [Scenario] = ('@QRFsnap' )
        )
    )
    and
    (
        (
            Measures3 = 'Beginning'
            and FiscalWeekNum = 1
        ) -- Get only data from first week of the quarter
        or (Measures3 = 'Net New')
    )
    and 1 = case
                when [Type2] in ( 'Total ARR' )
                     and [FX Conversion] in ( 'USD Current Plan Rate', 'USD as Reported' ) then
                    1 --- Total ARR Filters
                when [Type2] in ( 'Total Units' )
                     and [FX Conversion] in ( 'USD Current Plan Rate' )
                     and RoutetoMarket2 in ( 'SMB & Consumer', '#' )
                     and Product not in ( 'Stock D2P Returns', 'Stock on Demand', 'Sign Transactions', 'LIC', 'Shrink'
                                        , 'CP Default', 'CP005', 'CP016', 'CP040', 'CP080', 'CP150', 'CP500', 'CP001'
                                        ) then
                    1
                else
                    0
            end
group by [Scenario]
       , Offerings
       , [App Names]
       , [FX Conversion]
       , [Market Area - Name]
       , [Ind vs Team vs Ent]
       , [Enterprise BU - Name]
       , FINSYS_LoadDate
       , [Measures2]
       , [Measures3]
       , [RoutetoMarket2]
       , [Fiscal Quarter]
       , case
             when @Rday < 0 then
                 'QTD' -- Quarter has closed so all weeks are QTD
             when FiscalWeekNum < CW.WkNum
                  and [Route to Market - Subscription] <> 'Enterprise' then
                 'QTD'
             else
                 'QTG'
         end
       , internal_offering_custom0
       , [Route to Market - Subscription]
       , [Type2]
       , [Market Segment]
-- ) t1