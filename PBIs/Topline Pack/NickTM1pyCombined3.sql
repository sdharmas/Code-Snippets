select [app_names]
     , [enterprise_bu_name]
     , [fiscal_week]                  'Fiscal Week'
     , [fiscal_week3]                 'Fiscal Quarter'
     , [ind_vs_team_vs_ent]           'Ind vs Team vs Ent'
     , [internal_offering_custom]
     , [market_area_name]             'Market Area Name'
     , [market_segment]               'Market Segment'
     , case
           when [measures] = 'Gross New (Sell In)' then
               'Acquisition'
           when [measures] = 'Net Migrations' then
               'Migrations'
           else
               [measures]
       end                            as Measures2
     , a.[offerings]                  'Offerings'
     , [product]
     , [route_to_market_subscriptions]
     , [scenario]
     , a.[timestamp]
     , [type]
     , b.custom0_b2b
     , case
           when [type] = 'Total Units' then
               [value] * 1000
           else
               [value]
       end                            as [value]
from dmefinance.[dbo].[tm1_planning_subscriptions_cb_combined3] a
    left outer join dmefinance.dbo.topline_b2b_custom0_mapping  b
        on concat(
                     a.route_to_market_subscriptions
                   , a.[offerings]
                   , a.[app_names]
                   , a.[market_segment]
                   , a.[ind_vs_team_vs_ent]
                 ) = concat(
                               b.[Route to Market - Subscription]
                             , b.[Offerings]
                             , b.[App Names]
                             , b.[Market Segment]
                             , b.[Ind vs Team vs Ent]
                           )
where [type] = 'Total ARR'
      or
      (
          [type] = 'Total Units'
          and Product not in ( 'Stock D2P Returns', 'Stock on Demand', 'Sign Transactions', 'LIC', 'Shrink'
                             , 'CP Default', 'CP005', 'CP016', 'CP040', 'CP080', 'CP150', 'CP500', 'CP001'
                             )
          and route_to_market_subscriptions <> 'All Enterprise'
      )
