create procedure dbo.update_tm1_hourly_ARR_anomaly_check_tbl
as
drop table if exists #temp_CQ_ARR

declare @CW varchar(200) =
        (
            select distinct
                   TM1_Fiscal_WeekinYear
            from FINANCE_SYSTEMS.dbo.Date_FiscalDateLookup
            where [Relative Fiscal Quarter] = 0
                  and [Relative Fiscal Week] = 0
        )
declare @CQ varchar(200) =
        (
            select distinct
                   [TM1_Fiscal Qtr/Year]
            from FINANCE_SYSTEMS.dbo.Date_FiscalDateLookup
            where [Relative Fiscal Quarter] = 0
        )
select timestamp
     , sum(   case
                  when scenario = 'Actuals'
                       and route_to_market_subscriptions <> 'Enterprise'
                       and type = 'Total ARR'
                       and fiscal_week3 = @CQ
                       and fiscal_week < @CW then
                      value
                  else
                      0
              end
          ) / 1e6 as 'Actuals'
     , sum(   case
                  when scenario = 'Outlook - Current'
                       and type = 'Total ARR'
                       and fiscal_week3 = @CQ then
                      value
                  else
                      0
              end
          ) / 1e6 as 'Outlook'
into #temp_CQ_ARR
from [DMeFinance].[dbo].[tm1_planning_subscriptions_cb_combined3]
group by [timestamp]

select *
from #temp_CQ_ARR

truncate table dmefinance.dbo.tm1_hourly_ARR_anomaly_check

insert into dmefinance.dbo.tm1_hourly_ARR_anomaly_check
select *
from #temp_CQ_ARR

go
;

exec dbo.update_tm1_hourly_ARR_anomaly_check_tbl

