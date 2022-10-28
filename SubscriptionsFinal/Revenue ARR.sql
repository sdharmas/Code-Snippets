-- Revenue ARR 
select upper(trim(   case
                         when [Enterprise BU - Name] = 'Document Cloud (EB)' then
                             'Document Cloud'
                         when [Enterprise BU - Name] = 'Creative (EB)' then
                             'Creative'
                         else
                             [Enterprise BU - Name]
                     end
                 )
            )                                                       as [BU_EnterpriseID]
     , upper(trim([External BU - Name]))                            as [BU_ExternalID]
     , B.[FiscalWeekID]                                             as [FiscalWeekID]
     , upper(trim(isnull([Group - Name], '#')))                     as [GroupID]
     , upper(trim(isnull([InternalSegment - Name], '#')))           as [InternalSegmentID]
     , concat('#_', upper(trim(A.[Market Segment])))                as [MarketID]
     , upper(concat([Product], '-', [App Names], '-', [Offerings])) as [ProductID]
     , concat('#_', upper(trim(A.[Geo])))                           as [RegionID]
     , upper(trim([Route to Market - Subscription]))                as [RouteToMarketID]
     , upper(trim(isnull([Scenario], '#')))                         as [ScenarioID]
     , upper(trim(isnull([Type], '#')))                             as [TypeID]
     , [FX Conversion]
     , [Ind vs Team vs Ent]
     , [IndivdualVsTeam1]
     , [Measures]
     , [Measures1]
     , A.[Measures2]
     , M2.[Measures2Custom]
     , M2.Measures2CustomOrderBy
     , [Measures3]
     , [Measures4]
     , [Value]
     , [LoadDate]
from [dbo].[vw_TM1_Subs_Alex] A

    -- Limit Dates
    inner join
    (
        select distinct
               [TM1_Fiscal_WeekinYear] as [FiscalWeekID]
        from [dbo].[Date_FiscalDateLookup]
        where [Fiscal Year] >= convert(varchar(4), year(getdate()) - 2)
              and [Fiscal Year] <= convert(varchar(4), year(getdate()))
    )                         B
        on A.[Fiscal Week] = B.[FiscalWeekID]

    -- Measures 2 Custom 
    left join
    (
        select distinct
               isnull(Measures2, '#') as Measures2
             , case Measures2
                   when 'Net Migrations' then
                       'Migrat'
                   when 'Beginning' then
                       'Beginning'
                   when 'Attrition' then
                       'Cancel'
                   when 'Gross New (Sell In)' then
                       'Gross'
                   when 'Gross New (ASV)' then
                       'Gross New (ASV)'
                   when 'Gross New (Usage Based)' then
                       'Gross New (Usage Based)'
                   when 'Enterprise ARR Adjustments' then
                       'Ent ARR Adj'
                   when 'Other QE Adjustments' then
                       'Other'
                   else
                       'Other'
               end                    as Measures2Custom
             , case Measures2
                   when 'Net Migrations' then
                       3
                   when 'Beginning' then
                       4
                   when 'Attrition' then
                       2
                   when 'Gross New (Sell In)' then
                       1
                   when 'Gross New (ASV)' then
                       5
                   when 'Gross New (Usage Based)' then
                       6
                   when 'Enterprise ARR Adjustments' then
                       7
                   when 'Other QE Adjustments' then
                       8
                   else
                       8
               end                    as Measures2CustomOrderBy
        from [dbo].[vw_TM1_Subs_Alex] A
    )                         M2
        on isnull(A.Measures2, '#') = M2.Measures2;