with Tbl
as (select 'outlook' scenario
         , round(sum(   case
                            when scenario = 'Outlook - Current'
                                 and [Route to Market - Subscription] like '%Web%' then
                                Value
                            else
                                0
                        end
                    ) / 1e6
               , 2
                )    Web
         , round(sum(   case
                            when scenario = 'Outlook - Current'
                                 and [Route to Market - Subscription] = 'App Store' then
                                Value
                            else
                                0
                        end
                    ) / 1e6
               , 2
                )    'App Store'
         , round(sum(   case
                            when scenario = 'Outlook - Current'
                                 and [Route to Market - Subscription] in ( 'Reseller', 'Etail/Retail' ) then
                                Value
                            else
                                0
                        end
                    ) / 1e6
               , 2
                )    'Channel'
         , round(sum(   case
                            when scenario = 'Outlook - Current'
                                 and [Route to Market - Subscription] = 'Phone' then
                                Value
                            else
                                0
                        end
                    ) / 1e6
               , 2
                )    'Phone'
         , round(sum(   case
                            when scenario = 'Outlook - Current'
                                 and [RoutetoMarket2] = 'All Enterprise' then
                                Value
                            else
                                0
                        end
                    ) / 1e6
               , 2
                )    'Enterprise'
    from [dbo].[vw_TM1_Subs_Dash]
    where [Measures3] = 'Net New'
          and [FX Conversion] = 'USD Current Plan Rate'
          and [Fiscal Quarter] = '2022 Q3'
          and Type2 = 'Total ARR')
select scenario
     , RTM
     , ARR
from Tbl
    unpivot
    (
        ARR
        for RTM in (Web, "App Store", Channel, Phone, Enterprise)
    ) as unpivotRTM
