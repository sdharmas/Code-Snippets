select distinct
       Major_Product_Config
     --  , Route_To_Market
     , format(sum(Net_Revenue_USD), 'N0') Revenue
from vw_Revenue_Actuals
where Route_To_Market in ( 'Adobe.com', 'Reseller' )
      and [605 or 606] = '606'
      and [Fiscal Qtr/Year] = '2022-Q3'
      and
      (
          Major_Product_Config in ( 'FUL', 'EDU', 'UPG', 'OTH', 'UPP' )
          or Product_Config in ( 'AOO', 'AOOD', 'TERM', 'UAOO', 'UAOOD' )
      )
      and [INTERNAL SEGMENT] = 'IS15'
group by Major_Product_Config

-- select distinct
--        Major_Product_Config
-- from vw_Revenue_Actuals
-- where Major_Product_Config in ( 'FUL', 'EDU', 'UPG', 'OTH', 'UPP' )

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

 select 
 Route_To_Market
     , format(sum(Net_Revenue_USD), 'N0') RevenueUSD
 from vw_Revenue_Actuals    
     group by Route_To_Market

-- from vw_Revenue_Actuals
-- where Route_To_Market in ( 'Adobe.com', 'Reseller' )
--       and [605 or 606] = '606'
--       and [Fiscal Qtr/Year] = '2022-Q2'
--       and
--       (

--         Product_Config in ( 'AOO', 'UAOO' )
--       )
--       and [INTERNAL SEGMENT] = 'IS15'
-- group by        loaddate, Major_Product_Config, Product_Config, Product_Name, Product_Name_Desc, [605 or 606]
