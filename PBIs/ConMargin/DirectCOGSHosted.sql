select [Fiscal Year]
     , [Version]
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
               'Expense'
       end                                                                      as 'Clean COGS'
     , format(sum(coalesce([Value USD], 0)) + sum(coalesce([FX Adj], 0)), 'N0') as ProjLanding
from vw_Expense_Final_DME
where ((
           [Fiscal Year] = '2021'
           and [Version] = 'Actuals'
       )
      --   or
      --   (
      --       [Fiscal Year] = '2024'
      --       and [Version] in ( 'Forecast', 'FY24 Plan' )
      --   )
      )
      and [P&L Category] = 'COGS'
      and [CCH EVP Owner] in ( 'David W. DMe', 'Scott B. SDE' )
      and
    -- CleanCOGS
    case
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
            'Expense'
    end = 'Hosted'
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
    -- end = 'Document Cloud'
      and 1 = case
                  when [CCH Lvl 2 Name] in ( 'ADDX', 'Corp Development', 'Corp Strategy' ) then
                      0
                  else
                      1
              end
group by [Fiscal Year]
       , [Version]
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
                 'Expense'
         end
order by [Fiscal Year]
       , [Version]