with Tbl
as (select *
    from [dbo].[Headcount_Roles_WWFO])
(select *
      , Category  = 'HIRES'
      , SortOrder = 1
 from Tbl
 where Tbl.[HC Category L1] like '%Hires%')
union
(select *
      , Category  = 'TERMS'
      , SortOrder = 2
 from Tbl
 where Tbl.[HC Category L1] like '%TERMS%');