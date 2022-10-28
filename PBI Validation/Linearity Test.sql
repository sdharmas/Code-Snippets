select distinct [Fiscal Quarter] from [dbo].[vw_TM1_Revenue_Planning_Bookings_DME_Final]

select distinct [Bookings Adjustments], [Bookings Adjustments 1], [Total Bookings Adjustments] from [dbo].[vw_TM1_Revenue_Planning_Bookings_DME_Final]

select Scenario, [Licensing Type], [Planning Bookings DME_m], sum ([Value]) as ASV from [dbo].[vw_TM1_Revenue_Planning_Bookings_DME_Final]
where [External BU - Name] = 'Digital Media (XR)'
-- and [Planning Bookings DME_m] = 'Net ASV excluding M&S Attrition'
and [Licensing Type] = 'ETLA'
and [FX Conversion] = 'USD Current Plan Rate'
and [Scenario] in ('Actuals', 'Outlook - Current')
and [Fiscal Quarter] = '2022 Q3'
and [Total Bookings Adjustments] = 'Total Adjustments'

group by Scenario, [Licensing Type], [Planning Bookings DME_m]