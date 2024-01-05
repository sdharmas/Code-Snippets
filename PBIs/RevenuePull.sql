-- Revenue
declare @CQtr varchar(10) = '2024 Q1'
declare @CY varchar(10) = left(@CQtr, 4)
declare @ListofScenarios table
(
    scenario varchar(20)
)

insert into @ListofScenarios
values
('Actuals')
, ('2024 Plan')



select scenario
     , year 'Fiscal Year'
     , [Fiscal Quarter]
     , PC
     , format(sum(Revenue), 'N0') Revenue
from
(
    --  Get the CPG Pull  --
    select [Scenario]
         , [Year]
         , [Fiscal Quarter]
         , 'CPG' 'PC'
         , case
               when
               (
                   [Enterprise BU] = 'EB10'
                   and [Measures] = 'Adjusted Net New Revenue'
               ) then
                   1 * [Value]
               when
               (
                   [Enterprise BU] = 'EB10'
                   and [Measures] = 'Acrobat Revenue'
               ) then
                   -1 * [Value]
           end   as Revenue
    from [FINANCE_SYSTEMS].[dbo].[TM1_Revenue_Planning_Consolidated_Final]
    where [Scenario] in
          (
              select * from @ListofScenarios
          )
          and [FX Conversion] = 'USD'
          and ([External BU] = 'XR10')
          and left([Fiscal Quarter], 4)
          between @CY - 3 and @CY
    union all
    select [Scenario]
         , [Year]
         , [Fiscal Quarter]
         , 'CPG' 'PC'
         , case
               when [PMBU] = '15300'
                    and [Measures] = 'Adjusted Net New Revenue' then
                   -1 * [Value]
           end   as Revenue
    from [FINANCE_SYSTEMS].[dbo].[TM1_Revenue_Planning_Consolidated_Final]
    where [Scenario] in
          (
              select * from @ListofScenarios
          )
          and [FX Conversion] = 'USD'
          and ([External BU] = 'XR10')
          and left([Fiscal Quarter], 4)
          between @CY - 3 and @CY
    union all
    -- DPG and EPG pull -- 
    select [Scenario]
         , [Year]
         , [Fiscal Quarter]
         , case
               when (
                        [Enterprise BU] = 'EB15'
                        and [Measures] = 'Adjusted Net New Revenue'
                    )
                    or
                    (
                        [Enterprise BU] = 'EB10'
                        and [Measures] = 'Acrobat Revenue'
                    ) then
                   'DPG'
               when [PMBU] = '15300'
                    and [Measures] = 'Adjusted Net New Revenue' then
                   'EPG'
           end as PC
         , case
               when (
                        [Enterprise BU] = 'EB15'
                        and [Measures] = 'Adjusted Net New Revenue'
                    )
                    or
                    (
                        [Enterprise BU] = 'EB10'
                        and [Measures] = 'Acrobat Revenue'
                    ) then
                   [Value]
               when [PMBU] = '15300'
                    and [Measures] = 'Adjusted Net New Revenue' then
         ([Value])
           end as Revenue
    from [FINANCE_SYSTEMS].[dbo].[TM1_Revenue_Planning_Consolidated_Final]
    where [Scenario] in
          (
              select * from @ListofScenarios
          )
          and [FX Conversion] = 'USD'
          and ([External BU] = 'XR10')
          and left([Fiscal Quarter], 4)
          between @CY - 3 and @CY
) t2
where PC is not null
group by Scenario
       , [Year]
       , [Fiscal Quarter]
       , PC
order by PC
       , year
       , [Fiscal Quarter]

