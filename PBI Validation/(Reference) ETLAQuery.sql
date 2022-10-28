select DayOfCalendarDate
     , [Fiscal WeekinQtr]
from [dbo].[Date_FiscalDateLookup]
where DayOfCalendarDate = '2021-05-16'


-- select  split(DayOfCalendarDate,',') ARR, [Fiscal WeekinQtr] from  [dbo].[Date_FiscalDateLookup]
-- where DayOfCalendarDate = '2021-07-26'
drop table if exists #Test
declare @strText as varchar(300) = '5/16/2021'
declare @Year int = right(@strText, 4)
declare @dayyear as varchar(300) = substring(@strText, charindex('/', @strText) + 1, len(@strText))

select concat(
                 @Year
               , '-'
               , right('00' + left(@strtext, charindex('/', @strText) - 1), 2)
               , '-'
               , right('00' + left(@dayyear, charindex('/', @dayyear) - 1), 2)
             ) as YYYYMMDD
into #Test

select YYYYMMDD, right([Fiscal WeekinQtr],2) as Wk
from #Test testdate
    inner join
    (
        select DayOfCalendarDate
             , [Fiscal WeekinQtr]
        from [dbo].[Date_FiscalDateLookup]
    )      cal
        on cal.DayOfCalendarDate = testdate.YYYYMMDD

