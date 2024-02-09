select [Fiscal Year]
     , [Version]
     , [P&L Category]
     , [CCH EVP Owner]
     --  , [Profit Center Trimmed]
     , [Major Cost Element Grp Desc]
     -- format(
     , format((sum(coalesce([Value USD], 0)) + sum(coalesce([FX Adj], 0))), 'N0') as 'Exp Proj. Landing (Unallocated)'

from [vw_Expense_Final_DME]
where [Super Cost Element Grp Lvl 2 Desc] in ( 'Expenses', 'Manufacturing COGS' )
      --     and [IO Profit Center] = '1792'
      and right([IO Profit Center], 4) = '1792'
      and
      (
          (
              [Fiscal Year] >= '2021'
              and [Fiscal Year] < '2024'
              and [Version] = 'Actuals'
          )
          or
          (
              [Fiscal Year] = '2024'
              and [Version] in ( 'Forecast', 'FY24 Plan' )
          )
      )
      and [Version] = 'Actuals'
      and [P&L Category] = 'VARIABLE'
      and [CCH EVP Owner] in ( 'David W. DMe', 'Scott B. SDE' )
      and 1 = case
                  when [CCH Lvl 2 Name] in ( 'ADDX', 'Corp Development', 'Corp Strategy' ) then
                      0
                  else
                      1
              end
group by [Fiscal Year]
       , [Version]
       , [P&L Category]
       , [CCH EVP Owner]
       --    , [Profit Center Trimmed]
       , [Major Cost Element Grp Desc]

order by [Fiscal Year]
-- select distinct [IO Profit Center], [Profit Center Trimmed],  [Profit Center Desc] from vw_Expense_Final_DME       
-- where right( [IO Profit Center], 4) = '1792'