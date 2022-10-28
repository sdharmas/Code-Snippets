select distinct
       Major_Product_Config, Product_Config
     --  , Route_To_Market
     , format(sum(Net_Revenue_USD), 'N0') Revenue
from vw_Revenue_Actuals
where Route_To_Market in ( 'Adobe.com', 'Reseller' )
      and [605 or 606] = '606'
      and [Fiscal Qtr/Year] = '2022-Q3'
      and
      (

        Product_Config in ( 'AOO', 'AOOD', 'TERM', 'UAOO', 'UAOOD' )
      )
      and [INTERNAL SEGMENT] = 'IS15'
group by Major_Product_Config, Product_Config