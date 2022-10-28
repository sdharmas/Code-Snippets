with TblHC
as (select [Fiscal Per/Year]
         , [CCH Lvl 1 Name]
         , [Version]
         --[Employee ID], 
         --[Employee First Name], 
         --[Employee Last Name], 
         --[Employee Status], 
         , sum([Headcount]) as Heads
    from [FINANCE_SYSTEMS].[dbo].[vw_Headcount_Final_DME]
    where [Version] in ( 'Forecast', 'FY22 Q2 QRF TSFR ADJ', 'FY22 Plan TSFR ADJ' )
          and [Fiscal Year] > 2021
          and [Employee Group Name] = 'Regular'
          and right([Fiscal Per/Year], 2) in ( '03', '06', '09', '12' )
    group by [Fiscal Per/Year], [Version]
           , [CCH Lvl 1 Name])
select [Version]
    --  , [CCH Lvl 1 Name]
     , sum([2022-06]) Q2
     , sum([2022-09]) Q3
     , sum([2022-12]) Q3
from TblHC
    pivot
    (
        SUM(Heads)
        for [Fiscal Per/Year] in ([2022-06], [2022-09], [2022-12])
    ) as PivotTable
group by [Version]    
order by [Version]
