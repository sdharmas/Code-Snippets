with Tbl
as (select [Scenario]
         , [Route To Market 2]
         , round(sum(Value) / 1e6, 1) as Revenue
    from [dbo].[TM1_Revenue_Planning_Consolidated_Final]
    where [Route To Market 2] in ( 'Enterprise', 'SMB & Consumer' )
          and [Measures] = 'Adjusted Net New Revenue'
          and [External BU - Name] = 'Digital Media (XR)'
          and [Scenario] in ( 'Outlook - Current', 'Q2 QRF 2022', 'Actuals' )
          and [Fiscal Quarter] = '2022 Q2'
          and [FX Conversion] = 'USD'
    group by [Scenario]
           , [Route To Market 2])
   , TblBreakout
as (select [Route To Market 2]
         , [Outlook - Current]
         , [Q2 QRF 2022]
         , [Actuals]
    from Tbl
        pivot
        (
            sum(Revenue)
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
select [Route To Market 2]
     , [Outlook - Current]
     , [Q2 QRF 2022]
     , round([Outlook - Current] - [Q2 QRF 2022], 1) as "vs QRF"
     , [Actuals]
from TblUnion;