with TblBase
as (select [Fiscal Year]
         , [Version]
         , [P&L Category]
         , 'DIRECT EXPENSE BY MAJOR GL'  'Category'
         , [CCH Lvl 2 Name]
         , [CCH Lvl 3 Name]
         , [Enterprise BU Name]
         , case
               when [CCH Lvl 3 Name] in ( 'DME Mgmt L3', 'SDE Mgmt L3' ) then
                   'Digital Media Shared'
               when [CCH Lvl 2 Name] = 'GARCIA' then
                   'Digital Media Shared'
               when [Profit Center Trimmed] = '1792' then
                   'Express'
               else
                   [Enterprise BU Name]
           end                           CleanBU
         , [Major Cost Element Grp Desc]
         -- format(
         , (sum(coalesce([Value USD], 0)) + sum(coalesce([FX Adj], 0)))
         -- , 'N0') 
                                         as 'Exp (Unallocated)'
         , sum([Value USD @ Plan Rates]) as 'Exp'
    from vw_Expense_Final_DME
    where (
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
           , [CCH Lvl 3 Name]
           , [Enterprise BU Name])
select *
     , case
           when CleanBU = 'Other Solutions' then
               'Yes'
           when CleanBU = 'Digital Media Shared' then
               'Yes'
           else
               'No'
       end as 'Allocate Y/N'
     , case
           when CleanBU in ( 'Creative', 'Express', 'Digital Media Shared', 'Document Cloud' ) then
               'Yes'
           else
               'No'
       end as 'CMPG Y/N'
     , case
           when [CCH Lvl 2 Name] in ( 'ADDX', 'Corp Development', 'Corp Strategy' ) then
               'Yes'
           else
               'No'
       end as 'CCH Lvl 2 has ADDX, Corp Dev, Strategy?'
     , case
           when [P&L Category] = 'FIXED' then
               case
                   when [CleanBU] in ( 'Other Solutions', 'Digital Media Shared' )
                        and [Major Cost Element Grp Desc] = 'Transaction Fees' then
                       'Transaction Fees'
                   when [CleanBU] in ( 'Other Solutions', 'Digital Media Shared' )
                        and [CCH Lvl 2 Name] = 'CTO' then
                       'Shared Platforms - Fixed'
                   when [CleanBU] in ( 'Other Solutions', 'Digital Media Shared' )
                        and [CCH Lvl 3 Name] in ( 'Search and Sensei L3', 'CoreTech & Globalization L3' ) then
                       'Shared Platforms - Fixed'
                   when [CleanBU] in ( 'Other Solutions', 'Digital Media Shared' ) then
                       [CCH Lvl 2 Name]
                   else
                       'Direct to PG'
               end
           when [P&L Category] = 'COGS' then
               case
                   when [CleanBU] in ( 'Other Solutions', 'Digital Media Shared' )
                        and [Major Cost Element Grp Desc] = 'Transaction Fees' then
                       'Transaction Fees'
                   when [CleanBU] in ( 'Other Solutions', 'Digital Media Shared' )
                        and [CCH Lvl 2 Name] = 'CTO' then
                       'Shared Platforms - COGS'
                   when [CleanBU] in ( 'Other Solutions', 'Digital Media Shared' )
                        and [CCH Lvl 3 Name] in ( 'Search and Sensei L3', 'CoreTech & Globalization L3' ) then
                       'Shared Platforms - COGS'
                   when [CleanBU] in ( 'Other Solutions', 'Digital Media Shared' ) then
                       [CCH Lvl 2 Name]
                   else
                       'Direct to PG'
               end
           else
               'VARIABLE'
       end as 'Allocation Lookup'
from TblBase