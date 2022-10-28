drop table if exists #REV
drop table if exists #UNITS

select scenario
     , PerpRevenue
into #REV
from
(
    select [Scenario]
        -- [Major Product Config]
        --      , [Major Product Config - Name]
        --      , 
                        [Scenario]
         , sum([Value]) as PerpRevenue
    from [dbo].[TM1_Revenue_Planning_Consolidated_Final] TbRev
    where [Route To Market 2] in ( 'SMB & Consumer' )
          and [Measures] = 'Adjusted Net New Revenue'
          and [External BU - Name] = 'Digital Media (XR)'
          and [Enterprise BU - Name] = 'Document Cloud (EB)'
          and [Scenario] in ( 'Q2 QRF 2022' )
          and [Fiscal Quarter] = '2022 Q2'
          and [FX Conversion] = 'USD'
          and
          (
              [Major Product Config] like '%LIC%'
              or [Major Product Config] in ( 'EDU', 'FUL', 'UPG' )
          )
    group by [Scenario]
--        , [Major Product Config]
--        , [Major Product Config - Name]
) SUB


select scenario
     , Units
into #UNITS
from
(
    select [Scenario]
         , sum(Value) as Units
    from [dbo].[vw_TM1_Subs_Dash] TbUnits
    where [RoutetoMarket2] = 'SMB & Consumer'
          and [Measures3] = 'Net New'
          and [Scenario] = 'Q2 QRF 2022'
          and [FX Conversion] = 'USD Current Plan Rate'
          and [Fiscal Quarter] = '2022 Q2'
          and Type2 = 'Total Units'
          and Product1 = 'Perpetual'
    group by [Scenario]
) SUB

select RV.scenario
     , RV.PerpRevenue
     , UT.Units
     , RV.PerpRevenue/UT.Units as ARPU
from #REV             RV
    inner join #UNITS UT
        on UT.Scenario = RV.Scenario