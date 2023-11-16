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
declare @CFQtoday varchar(50) =
        (
            select [TM1_Fiscal Qtr/Year]
            from Date_FiscalDateLookup
            where DayOfCalendarDate = @today
        )
declare @RFQtoday varchar(50) =
        (
            select [Relative Fiscal Quarter]
            from Date_FiscalDateLookup
            where DayOfCalendarDate = @today
        )
declare @RFQQuarterEnd varchar(50) =
        (
            select [Relative Fiscal Quarter]
            from Date_FiscalDateLookup
            where DayOfCalendarDate = @lastdayofQtr
        )
declare @RFQ varchar(50) =
        (
            select case when @CFQtoday > @CQtr then @RFQQuarterEnd else @RFQtoday end
        )
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
--      , @lastdayofQtr   lastday
--      , @RdayQuarterEnd RdayQE
--      , @Rday           Rday
-- select distinct
--        [Fiscal Quarter]
--      , [Fiscal Week]
-- from
-- (
select @CQtr                            as 'Current Quarter'
     , internal_offering_custom0
     , [Scenario]
     , [Fiscal Quarter]
     , case
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
     , case
           when [Route to Market - Subscription] = 'Enterprise' then
               'ETLA'
           when [Route to Market - Subscription] in ( 'Phone - Named', 'Reseller - Named' ) then
               'VIP'
           when [Route to Market - Subscription] like '%Web%' then
               'Web'
           when [Route to Market - Subscription] in ( 'Phone', 'Phone Mid-Market' ) then
               'Phones'
           when [Route to Market - Subscription] = 'App Store' then
               'App Store'
           when [Route to Market - Subscription] = '#' then
               '#'
           else
               'Channel'
       end                              as RTM1
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
            [Fiscal Year] >= '2016'
            and [Fiscal Year] <= '2018'
            and [Scenario] = 'Actuals'
            and [Type2] = 'Total ARR'
        ) -- Actuals Total ARR from 2016, 2017, 2018
        or
        (
            [Fiscal Year] >= '2017'
            and [Fiscal Year] <= '2018'
            and [Scenario] = 'Actuals'
            and [Type2] = 'Total Units'
        ) -- Actuals Total Units from 2017, 2018
        or
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
            and [Scenario] in ( 'Outlook - Current', 'OL - Previous', @Plan, @QRF )
        ) --- Outlook - Current from Current Fiscal Quarter

        or
        (
            [Fiscal Year] > @CY
            and [Scenario] in ( 'FY24 Plan v1', 'Dashboard QRF' )
        )
        or
        (
            [Fiscal Year] > @CY
            and [Scenario] like ('%Ops Plan%')
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
--   and [Fiscal Quarter] = '2023 Q2'
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
             when FiscalWeekNum < CW.WkNum
                  and [Route to Market - Subscription] <> 'Enterprise' then
                 'QTD'
             else
                 'QTG'
         end
       , internal_offering_custom0
       , case
             when [Route to Market - Subscription] = 'Enterprise' then
                 'ETLA'
             when [Route to Market - Subscription] in ( 'Phone - Named', 'Reseller - Named' ) then
                 'VIP'
             when [Route to Market - Subscription] like '%Web%' then
                 'Web'
             when [Route to Market - Subscription] in ( 'Phone', 'Phone Mid-Market' ) then
                 'Phones'
             when [Route to Market - Subscription] = 'App Store' then
                 'App Store'
             when [Route to Market - Subscription] = '#' then
                 '#'
             else
                 'Channel'
         end
       , [Route to Market - Subscription]
       , [Type2]
       , [Market Segment]
-- ) t1