select [Fiscal Week]
     , round(sum(   case
                        when scenario = 'Outlook - Current' then
                            Value
                        else
                            0
                    end
                ) / 1e6
           , 2
            ) Outlook
     , round(sum(   case
                        when scenario = 'Actuals' then
                            Value
                        else
                            0
                    end
                ) / 1e6
           , 2
            ) Actuals
     , round(sum(   case
                        when scenario = 'Q3 QRF 2022' then
                            Value
                        else
                            0
                    end
                ) / 1e6
           , 2
            ) QRF
     , round((sum(   case
                         when scenario = 'Outlook - Current' then
                             Value
                         else
                             0
                     end
                 ) - sum(   case
                                when scenario = 'Q3 QRF 2022' then
                                    Value
                                else
                                    0
                            end
                        )
             ) / 1e6
           , 2
            ) DeltaQRF
from [dbo].[vw_TM1_Subs_Dash]
where [RoutetoMarket2] = 'SMB & Consumer'
      and [Measures3] = 'Net New'
      and [FX Conversion] = 'USD Current Plan Rate'
      and [Fiscal Quarter] = '2022 Q3'
      and Type2 = 'Total ARR'
group by [Fiscal Week]
order by [Fiscal Week]