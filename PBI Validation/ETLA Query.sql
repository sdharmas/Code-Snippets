drop table if exists #CurrPriorQtr
drop table if exists #ETLAPYCQ
drop table if exists #ETLACYCQ

-- Get CurrQtr and PY CurrQtr
select distinct
       concat(left([Current Quarter], 4), '-', right([Current Quarter], 2))     CYCurrQtr
     , concat(left([Current Quarter], 4) - 1, '-', right([Current Quarter], 2)) as PYCurrQtr
into #CurrPriorQtr
from vw_TM1_Subs_Dash

-- Get ETLA Table for CurrQtr
select [Fiscal Period]
     , [Fiscal Year]
     , [Fiscal Year - Quarter]
     , [Licensing Program]
     , [Licensing Program Type]
     , [Outlook Product Group]
     , [Outlook Type Bucket]
     , [Snapshot Fiscal Date]
     , [Geo (Sales FIN)]
     , [PMBU]
     , [IS]
     , [XR]
     , [RepSegment (Sales FIN)]
     , [DMEType]
     , [DMESalesPlay]
     , [DMELicType]
     , [CloseWk]
     , right([Fiscal WeekinQtr], 2) WkNum
     , [Close Date]
     , [Market Area (Sales FIN)]
     , [LoadDate]
     , [Source]
     , [Reportable Bookings Flag]
     , [DataSource]
     , sum([NewASV+UB])             as ASV
into #ETLACYCQ
from vw_SF_Pipeline_Analytics     sf
    inner join
    (select * from #CurrPriorQtr) as b
        on (b.CYCurrQtr = sf.[Fiscal Year - Quarter])
    inner join
    (
        select DayOfCalendarDate
             , [Fiscal WeekinQtr]
        from [dbo].[Date_FiscalDateLookup]
    )                             cal
        on cal.DayOfCalendarDate = sf.[Close Date]
where [Outlook Type Bucket] in ( 'Booked / In House'
                               -- , 'Committed Upside', 'Forecast' 
                               )
      and [XR] = 'Digital Media'
      and [Reportable Bookings Flag] = 'Yes'
      and [Snapshot Fiscal Date] = 'Latest Snapshot'
      and [DMELicType] like '%ETLA%'
group by [Fiscal Period]
       , [Fiscal Year]
       , [Fiscal Year - Quarter]
       , [Licensing Program]
       , [Licensing Program Type]
       , [Outlook Product Group]
       , [Outlook Type Bucket]
       , [Snapshot Fiscal Date]
       , [Geo (Sales FIN)]
       , [PMBU]
       , [IS]
       , [XR]
       , [RepSegment (Sales FIN)]
       , [DMEType]
       , [DMESalesPlay]
       , [DMELicType]
       , [CloseWk]
       , [Close Date]
       , [Market Area (Sales FIN)]
       , [LoadDate]
       , [Source]
       , [Reportable Bookings Flag]
       , [DataSource]
       , right([Fiscal WeekinQtr], 2)


-- Get ETLA Table for PYCurrQtr
select [Fiscal Period]
     , [Fiscal Year]
     , [Fiscal Year - Quarter]
     , [Licensing Program]
     , [Licensing Program Type]
     , [Outlook Product Group]
     , [Outlook Type Bucket]
     , [Snapshot Fiscal Date]
     , [Geo (Sales FIN)]
     , [PMBU]
     , [IS]
     , [XR]
     , [RepSegment (Sales FIN)]
     , [DMEType]
     , [DMESalesPlay]
     , [DMELicType]
     , [CloseWk]
     , right([Fiscal WeekinQtr], 2) WkNum
     , [Close Date]
     , [Market Area (Sales FIN)]
     , [LoadDate]
     , [Source]
     , [Reportable Bookings Flag]
     , [DataSource]
     , sum([NewASV+UB])             as ASV
into #ETLAPYCQ
from vw_SF_Pipeline_Analytics     sf
    inner join
    (select * from #CurrPriorQtr) as b
        on (b.PYCurrQtr = sf.[Fiscal Year - Quarter])
    inner join
    (
        select DayOfCalendarDate
             , [Fiscal WeekinQtr]
        from [dbo].[Date_FiscalDateLookup]
    )                             cal
        on cal.DayOfCalendarDate = sf.[Close Date]
where [Outlook Type Bucket] in ( 'Booked / In House'
                               -- , 'Committed Upside', 'Forecast' 
                               )
      and [XR] = 'Digital Media'
      and [Reportable Bookings Flag] = 'Yes'
      and [Snapshot Fiscal Date] = 'Latest Snapshot'
      and [DMELicType] like '%ETLA%'
group by [Fiscal Period]
       , [Fiscal Year]
       , [Fiscal Year - Quarter]
       , [Licensing Program]
       , [Licensing Program Type]
       , [Outlook Product Group]
       , [Outlook Type Bucket]
       , [Snapshot Fiscal Date]
       , [Geo (Sales FIN)]
       , [PMBU]
       , [IS]
       , [XR]
       , [RepSegment (Sales FIN)]
       , [DMEType]
       , [DMESalesPlay]
       , [DMELicType]
       , [CloseWk]
       , [Close Date]
       , [Market Area (Sales FIN)]
       , [LoadDate]
       , [Source]
       , [Reportable Bookings Flag]
       , [DataSource]
       , right([Fiscal WeekinQtr], 2)

-- Put Tables together
select *
from #ETLAPYCQ
union
select *
from #ETLACYCQ



