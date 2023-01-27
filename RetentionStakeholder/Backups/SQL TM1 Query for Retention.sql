select Periodicity,
       [FX Conversion],
       Scenario,
       Measures,
       [Market Segment],
       [Route to Market - Subscription],
       Offerings2,
       Offerings,
       Product1,
       Product,
       [App Names],
       [Ind vs Team vs Ent],
       Geo,
       [Market Area - Name],
       [Fiscal Week],
       Sum(Value) as Value
from dbo.TM1_Revenue_Planning_SubscriptionsFinal
where Periodicity = 'Value'
      and [FX Conversion] = 'USD'
      and (
              Scenario = 'Actuals'
              or Scenario = 'OL - Previous'
              or (
                     Scenario = 'QRF - Current'
                     and [Fiscal Quarter] = '2021 Q4'
                 )
          )
      and Measures = 'Gross New (Sell In)'
      and (
              [Route to Market - Subscription] = 'Phone'
              or [Route to Market - Subscription] Like '%Web%'
          )
      and Offerings not Like '%Perpetual%'
      and Product1 != 'Stock Credit Pack'
      and Product1 != 'Perpetual'
      and [Fiscal Week] >= '202107'
      and Type2 = 'Total Units'
group by Periodicity,
         [FX Conversion],
         Scenario,
         Measures,
         [Market Segment],
         [Route to Market - Subscription],
         Offerings2,
         Offerings,
         Product1,
         Product,
         [App Names],
         [Ind vs Team vs Ent],
         Geo,
         [Market Area - Name],
         [Fiscal Week]
		 
