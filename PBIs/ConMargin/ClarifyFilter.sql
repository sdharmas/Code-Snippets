with TblBase
as (select [Fiscal Year]
         , [Version]
         , [P&L Category]
         , 'DIRECT EXPENSE BY MAJOR GL'                                             'Category'
         , [CCH Lvl 2 Name]
         , [CCH Lvl 3 Name]
         , case
               when [CCH Lvl 3 Name] in ( 'DME Mgmt L3', 'SDE Mgmt L3' ) then
                   'Digital Media Shared'
               when [CCH Lvl 2 Name] = 'GARCIA' then
                   'Digital Media Shared'
               when [Profit Center Trimmed] = '1792' then
                   'Express'
               else
                   [Enterprise BU Name]
           end                                                                      CleanBU
         , [Major Cost Element Grp Desc]
          , sum(coalesce([Value USD], 0)) + sum(coalesce([FX Adj], 0)) as 'Exp (Unallocated)'
        , sum([Value USD @ Plan Rates]) as 'Exp'
    from vw_Expense_Final_DME
    where (
              (
                  [Fiscal Year] >= '2020'
                  and [Fiscal Year] < '2024'
                  and [Version] = 'Actuals'
              )
              or
              (
                  [Fiscal Year] = '2024'
                  and [Version] in ( 'Forecast', 'FY24 Plan' )
              )
          )
          and [P&L Category] = 'FIXED'
          and [CCH EVP Owner] in ( 'David W. DMe', 'Scott B. SDE' )
        --   and
        -- -- CleanEBU
        -- case
        --     when [CCH Lvl 3 Name] in ( 'DME Mgmt L3', 'SDE Mgmt L3' ) then
        --         'Digital Media Shared'
        --     when [CCH Lvl 2 Name] = 'GARCIA' then
        --         'Digital Media Shared'
        --     when [Profit Center Trimmed] = '1792' then
        --         'Express'
        --     else
        --         [Enterprise BU Name]
        -- end in ( 'Creative', 'Express', 'Digital Media Shared', 'Document Cloud' )
        --   and 1 = case
        --               when [CCH Lvl 2 Name] in ( 'ADDX', 'Corp Development', 'Corp Strategy' ) then
        --                   0
        --               else
        --                   1
        --           end
    group by [Fiscal Year]
           , [Version]
           , case
                 when [CCH Lvl 3 Name] in ( 'DME Mgmt L3', 'SDE Mgmt L3' ) then
                     'Digital Media Shared'
                 when [CCH Lvl 2 Name] = 'GARCIA' then
                     'Digital Media Shared'
                 when [Profit Center Trimmed] = '1792' then
                     'Express'
                 else
                     [Enterprise BU Name]
             end
           , [P&L Category]
           , [Major Cost Element Grp Desc]
           , [CCH Lvl 2 Name]
           , [CCH Lvl 3 Name])
select [Version], [Fiscal Year], format(sum([Exp (Unallocated)]),'N0') 'Proj', format(sum([Exp]),'N0') 'PlanRate'
 
from TblBase
group by [Version], [Fiscal Year]