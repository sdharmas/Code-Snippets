select [Fiscal Per/Year]
     , [CCH Lvl 1 Name]
    --  , [CCH Lvl 2 Name]
     , [Version]
     , [Employee Action Type]
     , [Load Date by Version]
     , format(sum([Headcount]),'N0') as Heads
from [FINANCE_SYSTEMS].[dbo].[vw_Headcount_Final_DME]
where [Version] in ( 'Forecast')
      and [Fiscal Year] > 2021
      and [Employee Group Name] = 'Regular'
      and right([Fiscal Per/Year], 2) in ( '03', '06', '09', '12' )
      and [CCH Lvl 1 Name] = 'David W. DMe CBO'
    --   and [CCH Lvl 2 Name] = 'STILL'
    --   and [Cost Center] <> '100613'
      and [Fiscal Per/Year] in ( '2022-09' )
group by [Fiscal Per/Year]
       , [CCH Lvl 1 Name]
       , [Version]
       , [Employee Action Type]
       , [Load Date by Version]
order by [Fiscal Per/Year], [Employee Action Type]



select [Fiscal Per/Year]
     , [CCH Lvl 1 Name]
    --  , [CCH Lvl 2 Name]
     , [Version]
    --  , [Employee Action Type]
     , [Load Date by Version]
     , format(sum([Headcount]),'N0') as Heads
from [FINANCE_SYSTEMS].[dbo].[vw_Headcount_Final_DME]
where [Version] in ( 'Forecast')
      and [Fiscal Year] > 2021
      and [Employee Group Name] = 'Regular'
      and right([Fiscal Per/Year], 2) in ( '03', '06', '09', '12' )
      and [CCH Lvl 1 Name] = 'David W. DMe CBO'
    --   and [CCH Lvl 2 Name] = 'STILL'
    --   and [Cost Center] <> '100613'
      and [Fiscal Per/Year] in ( '2022-09' )
group by [Fiscal Per/Year]
       , [CCH Lvl 1 Name]
       , [Version]
    --    , [Employee Action Type]
       , [Load Date by Version]
order by [Fiscal Per/Year]

