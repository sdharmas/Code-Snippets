declare @CQ varchar(20) =
        (
            select distinct
                   [Current Quarter]
            from [FINANCE_SYSTEMS].[dbo].[vw_TM1_Subs_Dash]
        )
-- select @CQ as CQ

declare @QRF varchar(20) = right(@CQ, 2) + ' QRF ' + left(@CQ, 4)
-- select @QRF as QRF

select A.RoutetoMarket2
     , R1.[Digital_vs_Field_RTM_03]
     , Scenario
     , left(A.FINSYS_LoadDate, 19)       as LoadDate
     , round(sum(Value) / 1e6, 1) as ARR
from [FINANCE_SYSTEMS].[dbo].[TM1_Revenue_PlanningSubscriptionsRTMSubs] R1
    join [FINANCE_SYSTEMS].[dbo].[vw_TM1_Subs_Dash]                     A
        on A.[Route to Market - Subscription] = R1.[RouteToMarket]
where [Measures3] = 'Net New'
      and ([Scenario] in ( 'Outlook - Current', 'OL - Previous', 'Actuals', @QRF ))
      and [Fiscal Quarter] = @CQ
      and Type2 = 'Total ARR'
      and [FX Conversion] = 'USD Current Plan Rate'
group by A.RoutetoMarket2
       , R1.[Digital_vs_Field_RTM_03]
       , Scenario
       , A.LoadDate
order by Scenario
       , A.RoutetoMarket2
       , R1.[Digital_vs_Field_RTM_03]


