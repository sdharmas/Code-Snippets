-- Remember to update the DMe Shared CCH2 List in the values section

declare @CCH2_DMeShared_list table
(
    id int identity(1, 1)
  , CCH2Name varchar(255)
);

insert into @CCH2_DMeShared_list
(
    CCH2Name
)
values
('DME Mgmt')
, ('SDE Mgmt')
, ('GARCIA');

-- select [Fiscal Year]
--      , [Version]
--      , [P&L Category]
--      , format(sum([Exp Plan Rates (unallocated)]), 'N0')    'PlanRate'
--      , format(sum([Exp Proj. Landing (Unallocated)]), 'N0') 'ProjLanding'
-- from
-- (
    select *
         , case
               when [CCH Lvl 2 Name] in ( 'ADDX', 'Corp Development', 'Corp Strategy' ) then
                   'Yes'
               else
                   'No'
           end as 'CCH Lvl 2 has ADDX, Corp Dev, Strategy?'
    from
    (
        select [Fiscal Year]
             , [Fiscal Qtr/Year]
             , [Version]
             , [COGS/OPEX CE Group]
             , [DME COGS Category]
             , [Reporting Area Desc]
             , [BWFA Sub Activity Desc]
             , [P&L Category]
             , case
                   when [P&L Category] = 'COGS' then
                       case
                           when charindex('contributor', [Reporting Area Desc]) > 0 then
                               'Contributor Royalty'
                           when charindex('hosted', [Reporting Area Desc]) > 0 then
                               'Hosted'
                           when charindex('content', [Reporting Area Desc]) > 0 then
                               'Content'
                           else
                               'COGS (other)'
                       end
                   else
                       [COGS/OPEX CE Group]
               end                                                          as 'DME COGS/OPEX (mapped)'
             , [CCH EVP Owner]
             , [CCH Lvl 1 Name]
             , [CCH Lvl 2 Name]
             , [CCH Lvl 3 Name]
             , [CCH Lvl 4 Name]
             , [Cost Center]
             , [Enterprise BU Name]
             , case
                   when [CCH Lvl 2 Name] in
                        (
                            select CCH2Name from @CCH2_DMeShared_list
                        ) then
                       'Digital Media Shared'
                   when [Profit Center Trimmed] = '1792' then
                       'Express'
                   else
                       [Enterprise BU Name]
               end                                                          CleanBU
             , [Major Cost Element Grp Desc]
             , (sum(coalesce([Value USD], 0)) + sum(coalesce([FX Adj], 0))) as 'Exp Proj. Landing (Unallocated)'
             , sum([Value USD @ Plan Rates])                                as 'Exp Plan Rates (unallocated)'
        from [vw_Expense_Final_DME]
        where [Super Cost Element Grp Lvl 2 Desc] in ( 'Expenses', 'Manufacturing COGS' )
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
        group by [Fiscal Year]
               , [Fiscal Qtr/Year]
               , [Version]
               , [CCH Lvl 2 Name]
               , [Profit Center Trimmed]
               , [Enterprise BU Name]
               , [COGS/OPEX CE Group]
               , [DME COGS Category]
               , [Reporting Area Desc]
               , [BWFA Sub Activity Desc]
               , [P&L Category]
               , case
                     when [P&L Category] = 'COGS' then
                         case
                             when charindex('contributor', [Reporting Area Desc]) > 0 then
                                 'Contributor Royalty'
                             when charindex('hosted', [Reporting Area Desc]) > 0 then
                                 'Hosted'
                             when charindex('content', [Reporting Area Desc]) > 0 then
                                 'Content'
                             else
                                 'Other COGS'
                         end
                     else
                         [COGS/OPEX CE Group]
                 end
               , [Major Cost Element Grp Desc]
               , [CCH EVP Owner]
               , [CCH Lvl 1 Name]
               , [CCH Lvl 2 Name]
               , [CCH Lvl 3 Name]
               , [CCH Lvl 4 Name]
               , [Cost Center]
               , [Enterprise BU Name]
    ) t1
-- ) t2
-- where [P&L Category] = 'FIXED'
--       and [Fiscal Year] = '2021'
--       and [Version] = 'Actuals'
--       and [CCH EVP Owner] in ( 'David W. DMe', 'Scott B. SDE' )
-- group by [Fiscal Year]
--        , [Version]
--        , [P&L Category]