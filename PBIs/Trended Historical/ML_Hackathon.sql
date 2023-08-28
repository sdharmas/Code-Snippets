select d1.[Market Area]
     , d1.product
     , d1.isAnomaly                MLtrend
     , d2.isAnomaly                DAXtrend
     , d1.isAnomaly - d2.isanomaly as Delta
from dbo.dev_yashjain_pod_dope_trended_anomalies4_ml             d1
    left join
    (select * from dbo.dev_yashjain_pod_dope_trended_anomalies3) d2
        on (
               d1.[Market Area] = d2.[Market Area]
               and d1.product = d2.product
           )