use DMeFinance
GO
select * from dbo.dev_yashjain_pod_dope_trended_anomalies3   
select * from dbo.dev_yashjain_pod_dope_trended_anomalies4_ml

select d1.[Market Area]
     , d1.product
     , d1.isAnomaly                DAXtrend

     , d2.isAnomaly                MLtrend
     , d1.isAnomaly - d2.isanomaly as Delta
from dbo.dev_yashjain_pod_dope_trended_anomalies3                   d1
    left join
    (select * from dbo.dev_yashjain_pod_dope_trended_anomalies4_ml) d2
        on (
               d1.[Market Area] = d2.[Market Area]
               and d1.product = d2.product
           )