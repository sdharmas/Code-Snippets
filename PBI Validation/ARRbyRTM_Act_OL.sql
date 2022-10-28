with TblOL
as (select 'outlook' scenario
         , round(sum(   case
                            when scenario = 'Outlook - Current'
                                 and [Route to Market - Subscription] like '%Web%' then
                                Value
                            else
                                0
                        end
                    ) / 1e6
               , 1
                )    Web
         , round(sum(   case
                            when scenario = 'Outlook - Current'
                                 and [Route to Market - Subscription] = 'App Store' then
                                Value
                            else
                                0
                        end
                    ) / 1e6
               , 1
                )    'App Store'
         , round(sum(   case
                            when scenario = 'Outlook - Current'
                                 and [Route to Market - Subscription] in ( 'Reseller', 'Etail/Retail' ) then
                                Value
                            else
                                0
                        end
                    ) / 1e6
               , 1
                )    'Channel'
         , round(sum(   case
                            when scenario = 'Outlook - Current'
                                 and [Route to Market - Subscription] = 'Phone' then
                                Value
                            else
                                0
                        end
                    ) / 1e6
               , 1
                )    'Phone'
         , round(sum(   case
                            when scenario = 'Outlook - Current'
                                 and [RoutetoMarket2] = 'All Enterprise' then
                                Value
                            else
                                0
                        end
                    ) / 1e6
               , 1
                )    'Enterprise'
         , max(   case
                      when scenario = 'Outlook - Current' then
                          [LoadDate]
                      else
                          0
                  end
              )      loadtime
    from [dbo].[vw_TM1_Subs_Dash]
    where [Measures3] = 'Net New'
          and [FX Conversion] = 'USD Current Plan Rate'
          and [Fiscal Quarter] = '2022 Q3'
          and Type2 = 'Total ARR')
   , TblAct
as (select 'actuals' scenario
         , round(sum(   case
                            when scenario = 'Actuals'
                                 and [Fiscal Week] <= [Current_FiscalWeek]
                                 and [Route to Market - Subscription] like '%Web%' then
                                Value
                            else
                                0
                        end
                    ) / 1e6
               , 1
                )    Web
         , round(sum(   case
                            when scenario = 'Actuals'
                                 and [Fiscal Week] <= [Current_FiscalWeek]
                                 and [Route to Market - Subscription] = 'App Store' then
                                Value
                            else
                                0
                        end
                    ) / 1e6
               , 1
                )    'App Store'
         , round(sum(   case
                            when scenario = 'Actuals'
                                 and [Fiscal Week] <= [Current_FiscalWeek]
                                 and [Route to Market - Subscription] in ( 'Reseller', 'Etail/Retail' ) then
                                Value
                            else
                                0
                        end
                    ) / 1e6
               , 1
                )    'Channel'
         , round(sum(   case
                            when scenario = 'Actuals'
                                 and [Fiscal Week] <= [Current_FiscalWeek]
                                 and [Route to Market - Subscription] = 'Phone' then
                                Value
                            else
                                0
                        end
                    ) / 1e6
               , 1
                )    'Phone'
         , round(sum(   case
                            when scenario = 'Actuals'
                                 and [Fiscal Week] <= [Current_FiscalWeek]
                                 and [RoutetoMarket2] = 'All Enterprise' then
                                Value
                            else
                                0
                        end
                    ) / 1e6
               , 1
                )    'Enterprise'
         , max(   case
                      when scenario = 'Outlook - Current' then
                          [LoadDate]
                      else
                          0
                  end
              )      loadtime
    from [dbo].[vw_TM1_Subs_Dash]
    where [Measures3] = 'Net New'
          and [FX Conversion] = 'USD Current Plan Rate'
          and [Fiscal Quarter] = '2022 Q3'
          and Type2 = 'Total ARR')
   , TblRTMOL
as (select loadtime
         , scenario
         , RTM
         , ARR
    from TblOL
        unpivot
        (
            ARR
            for RTM in (Web, "App Store", Channel, Phone, Enterprise)
        ) as unpivotRTM)
   , TblRTMAct
as (select loadtime
         , scenario
         , RTM
         , ARR
    from TblAct
        unpivot
        (
            ARR
            for RTM in (Web, "App Store", Channel, Phone, Enterprise)
        ) as unpivotRTM)
   , TblUnion
as (select *
    from TblRTMOL
    union
    select *
    from TblRTMAct)
select loadtime
     , scenario
     , RTM
     , case
           when RTM = 'Web' then
               1
           when RTM = 'App Store' then
               2
           when RTM = 'Channel' then
               3
           when RTM = 'Phone' then
               4
           else
               5
       end     'order'
     , ARR
from TblUnion
order by scenario
       , [order]
