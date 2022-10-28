declare @CY_Qtr as varchar(10) = '2022 Q2'
--DECLARE @PY_Qtr as VARCHAR(10) = '2021 Q2'

select [LoadDate]
     , [Route To Market 2]
     , [Outlook - Current]
     , QRF
     , Actuals
     , round([Outlook - Current] - QRF,2) [OL vs QRF]
from
(
select LoadDate
     , [Route To Market 2]
     , round(sum(   case
                        when Scenario = 'Outlook - Current'
                             and [Fiscal Quarter] = @CY_Qtr then
                            [Value]
                        else
                            0
                    end
                ) / 1000000
           , 2
            ) 'Outlook - Current'
     , round(sum(   case
                        when Scenario = 'Q2 QRF 2022'
                             and [Fiscal Quarter] = @CY_Qtr then
                            [Value]
                        else
                            0
                    end
                ) / 1000000
           , 2
            ) 'QRF'
     , round(sum(   case
                        when Scenario = 'Actuals'
                             and [Fiscal Quarter] = @CY_Qtr then
                            [Value]
                        else
                            0
                    end
                ) / 1000000
           , 2
            ) Actuals
from [dbo].[TM1_Revenue_Planning_Consolidated_Final]
where [Route To Market 2] in ( 'Enterprise', 'SMB & Consumer' )
      and [Measures] = 'Adjusted Net New Revenue'
      and [External BU - Name] = 'Digital Media (XR)'
      and [Scenario] in ( 'Outlook - Current', 'Q2 QRF 2022', 'Actuals' )
      and [Fiscal Quarter] = '2022 Q2'
      and [FX Conversion] = 'USD'
group by [LoadDate]
       , [Route To Market 2]
) base
order by 2
       , 1