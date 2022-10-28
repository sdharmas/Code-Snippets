-- Remember to change the QRF scenario at the bottom

select [Scenario]
     , [Route to Market - Subscription]
     , [Market Segment]
     , reg.[Region - Name]
     , Current_FiscalWeek
     , [App Names]
     , [Ind vs Team vs Ent]
     , [Offerings]
     , [Enterprise BU - Name]
     , [Fiscal Week]
     , [LoadDate]
     , [Measures2]
     , [Measures3]
     , [Measures4]
     , [Offerings2]
     , [Product1]
     , [RoutetoMarket2]
     , [Type2]
     , [Fiscal Quarter]
     , arr.[Geo]
     , [Current Quarter]
     , [FiscalWeekNum]
     , [Internal Offering Custom]
     , [CustomOffering1]
     , [CustomOffering2]
     , [CustomOffering3]
     , [CustomOffering4]
     , internal_offering_custom0
     , internal_offering_custom1
     , internal_offering_custom2
     , internal_offering_custom3
     , internal_offering_custom4
     , sum([Value]) as ValueAdj
from [FINANCE_SYSTEMS].[dbo].[vw_TM1_Subs_Dash]                                     arr
    inner join [FINANCE_SYSTEMS].[dbo].[TM1_Revenue_PlanningConsolidatedMarketArea] reg
        on reg.[Market Area - Name] = arr.[Market Area - Name]
where (
          [Fiscal Year] in ( '2019', '2020', '2021' )
          or [Fiscal Quarter] in ( '2022 Q1', '2022 Q2' )
      )
      and [Scenario] in ( 'Actuals - FY22 Segmentation' )
      and
      (
          Measures3 = 'Beginning'
          or Measures3 = 'Net New'
      )
      and [FX Conversion] = 'USD Current Plan Rate'
      and [Type2] = 'Total ARR'
group by [Scenario]
       , [Route to Market - Subscription]
       , [Market Segment]
       , reg.[Region - Name]
       , Current_FiscalWeek
       , [App Names]
       , [Ind vs Team vs Ent]
       , [Offerings]
       , [Enterprise BU - Name]
       , [Fiscal Week]
       , [LoadDate]
       , [Measures2]
       , [Measures3]
       , [Measures4]
       , [Offerings2]
       , [Product1]
       , [RoutetoMarket2]
       , [Type2]
       , [Fiscal Quarter]
       , arr.[Geo]
       , [Current Quarter]
       , [FiscalWeekNum]
       , [Internal Offering Custom]
       , [CustomOffering1]
       , [CustomOffering2]
       , [CustomOffering3]
       , [CustomOffering4]
       , internal_offering_custom0
       , internal_offering_custom1
       , internal_offering_custom2
       , internal_offering_custom3
       , internal_offering_custom4
union all
select [Scenario]
     , [Route to Market - Subscription]
     , [Market Segment]
     , reg.[Region - Name]
     , Current_FiscalWeek
     , [App Names]
     , [Ind vs Team vs Ent]
     , [Offerings]
     , [Enterprise BU - Name]
     , [Fiscal Week]
     , [LoadDate]
     , [Measures2]
     , [Measures3]
     , [Measures4]
     , [Offerings2]
     , [Product1]
     , [RoutetoMarket2]
     , [Type2]
     , [Fiscal Quarter]
     , arr.[Geo]
     , [Current Quarter]
     , [FiscalWeekNum]
     , [Internal Offering Custom]
     , [CustomOffering1]
     , [CustomOffering2]
     , [CustomOffering3]
     , [CustomOffering4]
     , internal_offering_custom0
     , internal_offering_custom1
     , internal_offering_custom2
     , internal_offering_custom3
     , internal_offering_custom4
     , sum([Value]) as ValueAdj
from [FINANCE_SYSTEMS].[dbo].[vw_TM1_Subs_Dash]                                     arr
    inner join [FINANCE_SYSTEMS].[dbo].[TM1_Revenue_PlanningConsolidatedMarketArea] reg
        on reg.[Market Area - Name] = arr.[Market Area - Name]
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
      and [FX Conversion] = 'USD Current Plan Rate'
      and [Type2] = 'Total ARR'
group by [Scenario]
       , [Route to Market - Subscription]
       , [Market Segment]
       , reg.[Region - Name]
       , Current_FiscalWeek
       , [App Names]
       , [Ind vs Team vs Ent]
       , [Offerings]
       , [Enterprise BU - Name]
       , [Fiscal Week]
       , [LoadDate]
       , [Measures2]
       , [Measures3]
       , [Measures4]
       , [Offerings2]
       , [Product1]
       , [RoutetoMarket2]
       , [Type2]
       , [Fiscal Quarter]
       , arr.[Geo]
       , [Current Quarter]
       , [FiscalWeekNum]
       , [Internal Offering Custom]
       , [CustomOffering1]
       , [CustomOffering2]
       , [CustomOffering3]
       , [CustomOffering4]
       , internal_offering_custom0
       , internal_offering_custom1
       , internal_offering_custom2
       , internal_offering_custom3
       , internal_offering_custom4
union all
select [Scenario]
     , [Route to Market - Subscription]
     , [Market Segment]
     , reg.[Region - Name]
     , Current_FiscalWeek
     , [App Names]
     , [Ind vs Team vs Ent]
     , [Offerings]
     , [Enterprise BU - Name]
     , [Fiscal Week]
     , [LoadDate]
     , [Measures2]
     , [Measures3]
     , [Measures4]
     , [Offerings2]
     , [Product1]
     , [RoutetoMarket2]
     , [Type2]
     , [Fiscal Quarter]
     , arr.[Geo]
     , [Current Quarter]
     , [FiscalWeekNum]
     , [Internal Offering Custom]
     , [CustomOffering1]
     , [CustomOffering2]
     , [CustomOffering3]
     , [CustomOffering4]
     , internal_offering_custom0
     , internal_offering_custom1
     , internal_offering_custom2
     , internal_offering_custom3
     , internal_offering_custom4
     , sum([Value]) as ValueAdj
from [FINANCE_SYSTEMS].[dbo].[vw_TM1_Subs_Dash]                                     arr
    inner join [FINANCE_SYSTEMS].[dbo].[TM1_Revenue_PlanningConsolidatedMarketArea] reg
        on reg.[Market Area - Name] = arr.[Market Area - Name]
where ([Fiscal Quarter] = [Current Quarter])
      and [Scenario] = ('Outlook - Current')
      and
      (
          Measures3 = 'Beginning'
          or Measures3 = 'Net New'
      )
      and [FX Conversion] = 'USD Current Plan Rate'
      and [Type2] = 'Total ARR'
group by [Scenario]
       , [Route to Market - Subscription]
       , [Market Segment]
       , reg.[Region - Name]
       , Current_FiscalWeek
       , [App Names]
       , [Ind vs Team vs Ent]
       , [Offerings]
       , [Enterprise BU - Name]
       , [Fiscal Week]
       , [LoadDate]
       , [Measures2]
       , [Measures3]
       , [Measures4]
       , [Offerings2]
       , [Product1]
       , [RoutetoMarket2]
       , [Type2]
       , [Fiscal Quarter]
       , arr.[Geo]
       , [Current Quarter]
       , [FiscalWeekNum]
       , [Internal Offering Custom]
       , [CustomOffering1]
       , [CustomOffering2]
       , [CustomOffering3]
       , [CustomOffering4]
       , internal_offering_custom0
       , internal_offering_custom1
       , internal_offering_custom2
       , internal_offering_custom3
       , internal_offering_custom4
union all
select [Scenario]
     , [Route to Market - Subscription]
     , [Market Segment]
     , reg.[Region - Name]
     , Current_FiscalWeek
     , [App Names]
     , [Ind vs Team vs Ent]
     , [Offerings]
     , [Enterprise BU - Name]
     , [Fiscal Week]
     , [LoadDate]
     , [Measures2]
     , [Measures3]
     , [Measures4]
     , [Offerings2]
     , [Product1]
     , [RoutetoMarket2]
     , [Type2]
     , [Fiscal Quarter]
     , arr.[Geo]
     , [Current Quarter]
     , [FiscalWeekNum]
     , [Internal Offering Custom]
     , [CustomOffering1]
     , [CustomOffering2]
     , [CustomOffering3]
     , [CustomOffering4]
     , internal_offering_custom0
     , internal_offering_custom1
     , internal_offering_custom2
     , internal_offering_custom3
     , internal_offering_custom4
     , sum([Value]) as ValueAdj
from [FINANCE_SYSTEMS].[dbo].[vw_TM1_Subs_Dash]                                     arr
    inner join [FINANCE_SYSTEMS].[dbo].[TM1_Revenue_PlanningConsolidatedMarketArea] reg
        on reg.[Market Area - Name] = arr.[Market Area - Name]
where ([Fiscal Quarter] = [Current Quarter])
      and [Scenario] = ('Q4 QRF 2022')
      and
      (
          Measures3 = 'Beginning'
          or Measures3 = 'Net New'
      )
      and [FX Conversion] = 'USD Current Plan Rate'
      and [Type2] = 'Total ARR'
group by [Scenario]
       , [Route to Market - Subscription]
       , [Market Segment]
       , reg.[Region - Name]
       , Current_FiscalWeek
       , [App Names]
       , [Ind vs Team vs Ent]
       , [Offerings]
       , [Enterprise BU - Name]
       , [Fiscal Week]
       , [LoadDate]
       , [Measures2]
       , [Measures3]
       , [Measures4]
       , [Offerings2]
       , [Product1]
       , [RoutetoMarket2]
       , [Type2]
       , [Fiscal Quarter]
       , arr.[Geo]
       , [Current Quarter]
       , [FiscalWeekNum]
       , [Internal Offering Custom]
       , [CustomOffering1]
       , [CustomOffering2]
       , [CustomOffering3]
       , [CustomOffering4]
       , internal_offering_custom0
       , internal_offering_custom1
       , internal_offering_custom2
       , internal_offering_custom3
       , internal_offering_custom4