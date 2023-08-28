select *
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