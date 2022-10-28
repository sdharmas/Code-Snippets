declare @term varchar(max) = 'Acrobat' 

-- Offerings
select * from [TM1_Revenue_PlanningSubscriptionsOfferings]
where Offerings like '%' + @term + '%' or
      Offerings1 like '%' + @term + '%' or 
 Offerings2 like '%' + @term + '%'

-- App Names
select * from [TM1_Revenue_PlanningSubscriptionsAppNames]
where AppNames like '%' + @term + '%'

-- Product
select * from [TM1_Revenue_PlanningSubscriptionsProduct]
where Product1 like '%' + @term + '%' or Product like '%' + @term + '%'
or Product2 like '%' + @term + '%'

select * from [TM1_Revenue_PlanningConsolidatedProfitCenter]
where [Profit Center] like '%' + @term + '%' or
      [Profit Center - Name] like '%' + @term + '%' or
 [InternalSegment] like '%' + @term + '%' or
 [InternalSegment - Name] like '%' + @term + '%'
