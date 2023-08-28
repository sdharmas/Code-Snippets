drop table dmefinance.dbo.tm1_hourly_ARR_anomaly_check

create table dmefinance.dbo.tm1_hourly_ARR_anomaly_check
(
    [timestamp] datetime
  , [Actuals] float
  , [Outlook] float
)

select *
from dmefinance.dbo.tm1_hourly_ARR_anomaly_check

alter table dmefinance.dbo.tm1_hourly_ARR_anomaly_check
add id int identity(1, 1) not null;

alter table dmefinance.dbo.tm1_hourly_ARR_anomaly_check
add
    primary key (id);

truncate table dmefinance.dbo.tm1_hourly_ARR_anomaly_check

select * from dmefinance.dbo.tm1_hourly_ARR_anomaly_check    