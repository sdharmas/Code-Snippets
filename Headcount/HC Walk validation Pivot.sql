with Tbl
as (select [Fiscal Per/Year]
         , [CCH Lvl 1 Name]
         --  , [CCH Lvl 2 Name]
         , [Version]
         , [Employee Action Type]
         , [Load Date by Version]
         , sum([Headcount]) as Heads
    from [FINANCE_SYSTEMS].[dbo].[vw_Headcount_Final_DME]
    where [Version] in ( 'Forecast' )
          and [Fiscal Year] > 2021
          and [Employee Group Name] = 'Regular'
          and right([Fiscal Per/Year], 2) in ( '03', '06', '09', '12' )
          and [CCH Lvl 1 Name] = 'David W. DMe CBO'
          --   and [CCH Lvl 2 Name] = 'STILL'
          --   and [Cost Center] <> '100613'
          and [Fiscal Per/Year] in ( '2022-09', '2022-12' )
    group by [Fiscal Per/Year]
           , [CCH Lvl 1 Name]
           , [Version]
           , [Employee Action Type]
           , [Load Date by Version])
select [Version]
     , [CCH Lvl 1 Name]
     , [Employee Action Type]
      
    , format(sum([2022-06]),'N0') Q2
     , format(sum([2022-09]), 'N0')                    Q3
     , format(sum([2022-12]), 'N0')                    Q4
     , format((sum([2022-12]) - sum([2022-09])), 'N0') as diff
from Tbl
    pivot
    (
        SUM(Heads)
        for [Fiscal Per/Year] in ([2022-06], [2022-09], [2022-12])
    ) as PivotTable
group by [Version]
       , [CCH Lvl 1 Name]
       , [Employee Action Type]
order by [Version]

-- with Tbl2
-- as (select [Fiscal Per/Year]
--          , [CCH Lvl 1 Name]
--          --  , [CCH Lvl 2 Name]
--          , [Version]
--          , [Employee Action Type]
--          , [Load Date by Version]
--          , sum([Headcount]) as Heads
--     from [FINANCE_SYSTEMS].[dbo].[vw_Headcount_Final_DME]
--     where [Version] in ( 'Forecast' )
--           and [Fiscal Year] > 2021
--           and [Employee Group Name] = 'Regular'
--           and right([Fiscal Per/Year], 2) in ( '03', '06', '09', '12' )
--           and [CCH Lvl 1 Name] = 'David W. DMe CBO'
--           --   and [CCH Lvl 2 Name] = 'STILL'
--           --   and [Cost Center] <> '100613'
--           and [Fiscal Per/Year] in ( '2022-09', '2022-12' )
--     group by [Fiscal Per/Year]
--            , [CCH Lvl 1 Name]
--            , [Version]
--            , [Employee Action Type]
--            , [Load Date by Version])
-- select [Version]
--      , [CCH Lvl 1 Name]
--     --  , [Employee Action Type]
--       , format(sum([2022-06]),'N0') Q2
--      , format(sum([2022-09]), 'N0')                    Q3
--      , format(sum([2022-12]), 'N0')                    Q4
--      , format((sum([2022-12]) - sum([2022-09])), 'N0') as diff
-- from Tbl2
--     pivot
--     (
--         SUM(Heads)
--         for [Fiscal Per/Year] in ([2022-06], [2022-09], [2022-12])
--     ) as PivotTable
-- group by [Version]
--        , [CCH Lvl 1 Name]
--     --    , [Employee Action Type]
-- order by [Version]

