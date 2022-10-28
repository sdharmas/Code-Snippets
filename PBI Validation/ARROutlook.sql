use [FINANCE_SYSTEMS]
GO

with Tbl
as (select [Scenario]
         , [RoutetoMarket2]
         , round(sum(Value) / 1e6, 1) as ARR
    from [dbo].[vw_TM1_Subs_Dash]
    where [RoutetoMarket2] in ( 'All Enterprise', 'SMB & Consumer' )
          and [Measures3] = 'Net New'
          and
          (
              (
                  [Scenario] in ( 'Outlook - Current', 'OL - Previous', 'Q2 QRF 2022' )
                  and [FX Conversion] = ('USD Current Plan Rate')
              )
              or
              (
                  [Scenario] = 'Actuals'
                  and [FX Conversion] = 'USD as Reported'
              )
          )
          and [Fiscal Quarter] = '2022 Q2'
          and Type2 = 'Total ARR'
    group by [Scenario]
           , [RoutetoMarket2])
   , TblBreakout
as (select  [RoutetoMarket2]
         , [Outlook - Current]
         , [Q2 QRF 2022]
         , [Actuals]
    from Tbl
        pivot
        (
            sum(ARR)
            for Tbl.Scenario in ([Actuals], [Q2 QRF 2022], [Outlook - Current])
        ) as scenario_pivot)
   , TblTotal
as (select 'Total'                  as "Route to Market 2"
         , sum([Outlook - Current]) "Outlook-Current"
         , sum([Q2 QRF 2022])       "Q2 QRF 2022"
         , sum([Actuals])           "Actuals"
    from TblBreakout)
   , TblUnion
as (select *
    from TblBreakout
    union
    select *
    from TblTotal)
select [RoutetoMarket2]
     , [Outlook - Current]
     , [Q2 QRF 2022]
     , round([Outlook - Current] - [Q2 QRF 2022], 1) as "vs QRF"
     , [Actuals]
from TblUnion;