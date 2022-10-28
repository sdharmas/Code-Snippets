-- Find the distinct Fiscal Weeks
select distinct
       [Fiscal Week]
from vw_TM1_Subs_Dash
order by 1








-- Count the number of Fiscal Weeks
select count(*) NumofRows
from
(select distinct [Fiscal Week] from vw_TM1_Subs_Dash) Tbl







-- Count the number of Fiscal Weeks in a given quarter
select count(*) NumofRows
from
(
    select distinct
           [Fiscal Week]
    from vw_TM1_Subs_Dash
    where [Fiscal Quarter] = '2022 Q4'
) Tbl








-- Find ARR by scenario (Actuals) for Current Quarter
select [Fiscal Quarter]
     , [scenario]
     , geo
     , sum(value) ARR
from vw_TM1_Subs_Dash
where [Fiscal Quarter] = '2022 Q4'
      and scenario = 'Actuals'
group by [Fiscal Quarter]
       , scenario
       , geo