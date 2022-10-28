-- C&B W
select *
from [dbo].[vw_FinSys_Security]
where [Group/Object] in ( 'BI_PLAT_C&B_FINANCE_EU', 'BI_PLAT_C&B_FINANCE_SU' )
order by LDAP

-- OpsStaff
select *
from [dbo].[vw_FinSys_Security]
where [Group/Object] in ( 'BI_PLAT_DME_FIN_OPSSTAFF_EU', 'BI_PLAT_DME_FIN_OPSSTAFF_SU' )
order by LDAP

-- DMe Finance
select *
from [dbo].[vw_FinSys_Security]
where [Group/Object] in ( 'BI_PLAT_DME_FINANCE_EU', 'BI_PLAT_DME_FINANCE_SU' )
order by LDAP



