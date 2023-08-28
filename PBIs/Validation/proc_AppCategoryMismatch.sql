-- The SharePoint file to SQL is updated via PowerAutomate DetectAppHierarchyLeafCellMismatches flow
-- Rember to update the TM1 ETL prod/dev table reference in Line 25, will require ALTER PROCEDURE

-- create PROCEDURE [dbo].[procAppCategoryMismatches] as

ALTER PROCEDURE [dbo].[procAppCategoryMismatches] as

drop table if exists #temptbl

select ProdTM1ETL
     , SharePoint into #temptbl
from
(
    select distinct
           p.[internal_offering_custom] as 'ProdTM1ETL'
         , d.internal_offering_custom0  as 'SharePoint'
         , cast(case
                    when p.internal_offering_custom = d.internal_offering_custom0 then
                        ''
                    when p.internal_offering_custom is null then
                        'SPextra'
                    else
                        'TM1extra'
                end as varchar(20))     mismatch
    from [DMeFinance].[dbo].[tm1_planning_subscriptions_cb_combined_dev] p
        full join
        (
            select distinct
                   internal_offering_custom0
            from [DMeFinance].[dbo].[dimSharePointinternal_offering_custom]
        )                                                                d
            on d.internal_offering_custom0 = p.internal_offering_custom
) t1
where [mismatch] = 'TM1extra'



truncate table dmefinance.dbo.dimAppCategoryLeafMismatches


insert into dmefinance.dbo.dimAppCategoryLeafMismatches
select *
from #temptbl

GO

-- select * from dmefinance.dbo.dimAppCategoryLeafMismatches



