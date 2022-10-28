USE FINANCE_SYSTEMS
GO

Declare @LoadDate DATETIME 

--Get the max load date
set @LoadDate=
				(Select max([Load Date by Version]) as [Load Date by Version]
				From dbo.vw_Headcount_Final_LDAP_Filtered 
				Where  dbo.vw_Headcount_Final_LDAP_Filtered.[Fiscal Year] >= 2018 
						And dbo.vw_Headcount_Final_LDAP_Filtered.Version = 'Forecast');

--helper cte to filter out information
with cteTrajec as
	(Select LTRIM(RTRIM([Version])) AS [Version]--trim all potential trailing spaces
			,LTRIM(RTRIM([Cost Center])) AS [Cost Center]
			,[Curr Fiscal Per/Year] AS [Current Fiscal Period] --rename field name to be consistent, required in alteryx
			,[Curr Fiscal Qtr/Year] AS [Current Fiscal Qtr] --rename field name to be consistent, required in alteryx
			,LTRIM(RTRIM([Fiscal Per/Year])) AS [Fiscal Per/Year]
			,LTRIM(RTRIM([Fiscal Period])) AS [Fiscal Period]
			,LTRIM(RTRIM([Fiscal Qtr/Year])) AS [Fiscal Qtr/Year]
			,LTRIM(RTRIM([Fiscal Year])) AS [Fiscal Year]
			,LTRIM(RTRIM([Functional Area])) AS [Functional Area]
			,LTRIM(RTRIM([Functional Controller LDAP])) AS [Functional Controller LDAP]
			,LTRIM(RTRIM([Load Date by Version])) AS [Load Date by Version]
			,LTRIM(RTRIM(@LoadDate)) as [Max Load Date]
			,Datediff(hour,[Load Date by Version],@LoadDate) as [Diff]
			,LTRIM(RTRIM([REPORTING AREA])) AS [REPORTING AREA]
			,LTRIM(RTRIM([ROW / IRC])) AS [ROW / IRC]
			,LTRIM(RTRIM([CCH Lvl 1 Name])) AS [CCH Lvl 1 Name]
			,LTRIM(RTRIM([CCH Lvl 2 Name])) AS [CCH Lvl 2 Name]
			,LTRIM(RTRIM([CCH Lvl 3 Name])) AS [CCH Lvl 3 Name]
			,LTRIM(RTRIM([CCH Lvl 4 Name])) AS [CCH Lvl 4 Name]
			,LTRIM(RTRIM([CCH Lvl 5 Name])) AS [CCH Lvl 5 Name]
			,LTRIM(RTRIM([CCH Lvl 6 Name])) AS [CCH Lvl 6 Name]
			,LTRIM(RTRIM([Employee First Name])) AS [Employee First Name]
			,LTRIM(RTRIM([Employee Group Name])) AS [Employee Group Name]
			,LTRIM(RTRIM([Employee ID])) AS [Employee ID]
			,LTRIM(RTRIM([Employee Last Name])) AS [Employee Last Name]
			,LTRIM(RTRIM([Employee LDAP])) AS [Employee LDAP]
			,LTRIM(RTRIM([Employee Status])) AS [Employee Status]
			,LTRIM(RTRIM([Employee Status (All versions)])) AS [Employee Status (All versions)]
			,LTRIM(RTRIM([Enterprise BU Desc])) AS [Enterprise BU Desc]
			,LTRIM(RTRIM([Field Controller Email])) AS [Field Controller Email]
			,LTRIM(RTRIM([Final End Date])) AS [Final End Date]
			,LTRIM(RTRIM([Final End Date - Fiscal Period])) AS [Final End Date - Fiscal Period]
			,LTRIM(RTRIM([Final End Date - Fiscal Qtr])) AS [Final End Date - Fiscal Qtr]
			,LTRIM(RTRIM([Final Start Date])) AS [Final Start Date]
			,LTRIM(RTRIM([Final Start Date - Fiscal Period])) AS [Final Start Date - Fiscal Period]
			,LTRIM(RTRIM([Final Start Date - Fiscal Qtr])) AS [Final Start Date - Fiscal Qtr]
			,LTRIM(RTRIM([Fiscal Qtr/Year & Version])) AS [Fiscal Qtr/Year & Version]
			,LTRIM(RTRIM([FTE %])) AS [FTE %]
			,LTRIM(RTRIM([Fulltime Hours])) AS [Fulltime Hours]
			,LTRIM(RTRIM([Fulltime/Parttime Flag])) AS [Fulltime/Parttime Flag]
			,LTRIM(RTRIM([Functional Controller Email])) AS [Functional Controller Email]
			,isnull([Headcount],0) AS [Headcount]
			,LTRIM(RTRIM([Latest Outlook Version Week])) AS [Latest Outlook Version Week]
			,LTRIM(RTRIM([WWFO Reporting])) AS [WWFO Reporting]
			,LTRIM(RTRIM([Internal Hire Flag])) AS [Internal Hire Flag]
			,LTRIM(RTRIM([Internal Hire Effective Date])) AS [Internal Hire Effective Date]
			,LTRIM(RTRIM([Internal Hire Effective Per/Year])) AS [Internal Hire Effective Per/Year]
			,LTRIM(RTRIM([Internal Hire Effective Qtr/Year])) AS [Internal Hire Effective Qtr/Year] 
			,LTRIM(RTRIM([Plan Headcount])) AS [Plan Headcount]
			,LTRIM(RTRIM([Cap Year])) AS [Cap Year]
			,LTRIM(RTRIM([Role Type])) AS [Role Type]
			,LTRIM(RTRIM([Employee Action Type])) AS [Employee Action Type]
			--New field 'Main HC Filter' 
		,(case when [Employee Status] ='Active' or [Employee Status] ='On Leave' or [Employee Status] ='Outlook' or [Employee Status] ='' then 'Active HC'
		       when [Employee Status] ='Terminated' or [Employee Status] ='Retired' then 'Terms Regular'
		       else 'Terms Non Regular'
		  end) as [Main HC Filter]
		--New field 'Month3_Per'
		,(case when right([Fiscal Per/Year],2)='01' or right([Fiscal Per/Year],2)='02' THEN '03' 
		       when right([Fiscal Per/Year],2)='04' or right([Fiscal Per/Year],2)='05' THEN '06'
               when right([Fiscal Per/Year],2)='07' or right([Fiscal Per/Year],2)='08' THEN '09'
			   when right([Fiscal Per/Year],2)='10' or right([Fiscal Per/Year],2)='11' THEN '12'
			   else right([Fiscal Per/Year],2)
			   end) as [Month3_Per]
		--New field 'Month3_FPer'
		,(case when right([Fiscal Per/Year],2)='01' or right([Fiscal Per/Year],2)='02' THEN left([Fiscal Per/Year],4)+'-'+'03' 
		       when right([Fiscal Per/Year],2)='04' or right([Fiscal Per/Year],2)='05' THEN left([Fiscal Per/Year],4)+'-'+'06'
               when right([Fiscal Per/Year],2)='07' or right([Fiscal Per/Year],2)='08' THEN left([Fiscal Per/Year],4)+'-'+'09'
			   when right([Fiscal Per/Year],2)='10' or right([Fiscal Per/Year],2)='11' THEN left([Fiscal Per/Year],4)+'-'+'12'
			   else left([Fiscal Per/Year],4)+'-'+ right([Fiscal Per/Year],2)
			   end) as [Month3_FPer]
		--New field 'Month1_Per'
		,(case when right([Fiscal Per/Year],2)='02' or right([Fiscal Per/Year],2)='03' THEN '01' 
		       when right([Fiscal Per/Year],2)='05' or right([Fiscal Per/Year],2)='06' THEN '04'
		       when right([Fiscal Per/Year],2)='08' or right([Fiscal Per/Year],2)='09' THEN '07'
		       when right([Fiscal Per/Year],2)='11' or right([Fiscal Per/Year],2)='12' THEN '10'
		       else right([Fiscal Per/Year],2)
			   end) as [Month1_Per]
		--New field 'Month1_FPer'
		,(case when right([Fiscal Per/Year],2)='02' or right([Fiscal Per/Year],2)='03' THEN left([Fiscal Per/Year],4)+'-'+'01' 
		       when right([Fiscal Per/Year],2)='05' or right([Fiscal Per/Year],2)='06' THEN left([Fiscal Per/Year],4)+'-'+'04'
		       when right([Fiscal Per/Year],2)='08' or right([Fiscal Per/Year],2)='09' THEN left([Fiscal Per/Year],4)+'-'+'07'
		       when right([Fiscal Per/Year],2)='11' or right([Fiscal Per/Year],2)='12' THEN left([Fiscal Per/Year],4)+'-'+'10'
		       else left([Fiscal Per/Year],4)+'-'+right([Fiscal Per/Year],2)
			   end) as [Month1_FPer]
	From dbo.vw_Headcount_Final_LDAP_Filtered 
	Where  dbo.vw_Headcount_Final_LDAP_Filtered.[Fiscal Year] >= 2018 
			and dbo.vw_Headcount_Final_LDAP_Filtered.[Version] = 'Forecast'
			and ([Employee Group Name] = 'University' or [Employee Group Name] = 'Regular'))

--Second helper cte to pivot Quarter information
,ctePivotQtr as
		(Select [Functional Area]
				,[CCH Lvl 2 Name]
				--,max(case when [Fiscal Qtr/Year]='2020_Q1' then [Sum_Ending_Headcount] end) as [2020_Q1]
				--,max(case when [Fiscal Qtr/Year]='2020_Q2' then [Sum_Ending_Headcount] end) as [2020_Q2]
				--,max(case when [Fiscal Qtr/Year]='2020_Q3' then [Sum_Ending_Headcount] end) as [2020_Q3]
				--,max(case when [Fiscal Qtr/Year]='2020_Q4' then [Sum_Ending_Headcount] end) as [2020_Q4]
				,[Fiscal Qtr/Year]
				,sum([Ending Headcount]) as [Sum_Ending_Headcount]
		from
				--Current Qtr Actuals and Forecasts
				(Select [Version]
						,[Fiscal Qtr/Year]
						--,[Cost Center]
						,[CCH Lvl 1 Name]
						,[CCH Lvl 2 Name]
						,[CCH Lvl 3 Name]
						,[Functional Area]
						,[ROW / IRC]
						,[Functional Controller LDAP]
						--,[Employee Action Type]
						,sum([Headcount]) as [Ending Headcount]
				from cteTrajec
				where [Diff]<1 and [Fiscal Qtr/Year] = [Current Fiscal Qtr] and right([Fiscal Per/Year],2)>=right([Current Fiscal Period],2) and [Fiscal Per/Year]=[Month3_FPer]
				group by [Version]
						,[Fiscal Qtr/Year]
				--		,[Cost Center]
						,[CCH Lvl 1 Name]
						,[CCH Lvl 2 Name]
						,[CCH Lvl 3 Name]
						,[Functional Area]
						,[ROW / IRC]
						,[Functional Controller LDAP]
				--		,[Employee Action Type]

					union all 

				--Prior Qtr Actuals and future Qtr
				Select [Version]
						,[Fiscal Qtr/Year]
						--,[Cost Center]
						,[CCH Lvl 1 Name]
						,[CCH Lvl 2 Name]
						,[CCH Lvl 3 Name]
						,[Functional Area]
						,[ROW / IRC]
						,[Functional Controller LDAP]
						--,[Employee Action Type]
						,sum([Headcount]) as [Ending Headcount]
				from cteTrajec
				where [Diff]<1 and [Fiscal Qtr/Year] <> [Current Fiscal Qtr] and left([Fiscal Qtr/Year],4)>=left([Current Fiscal Qtr],4) and [Fiscal Per/Year]=[Month3_FPer]
				group by [Version]
						,[Fiscal Qtr/Year]
						--,[Cost Center]
						,[CCH Lvl 1 Name]
						,[CCH Lvl 2 Name]
						,[CCH Lvl 3 Name]
						,[Functional Area]
						,[ROW / IRC]
						,[Functional Controller LDAP]) as tblTrajec
						--,[Employee Action Type]
		group by [Functional Area]
				,[CCH Lvl 2 Name]
				,[Fiscal Qtr/Year])
Select [Functional Area]
		,[CCH Lvl 2 Name]
		,[2020_Q1]
		,[2020_Q2]
		,[2020_Q3]
		,[2020_Q4]
from
--Results per quarter per CCH lvl2
	
	(Select [Functional Area]
			,[CCH Lvl 2 Name]
			,max(case when [Fiscal Qtr/Year]='2020-Q1' then [Sum_Ending_Headcount] end) as [2020_Q1]
			,max(case when [Fiscal Qtr/Year]='2020-Q2' then [Sum_Ending_Headcount] end) as [2020_Q2]
			,max(case when [Fiscal Qtr/Year]='2020-Q3' then [Sum_Ending_Headcount] end) as [2020_Q3]
			,max(case when [Fiscal Qtr/Year]='2020-Q4' then [Sum_Ending_Headcount] end) as [2020_Q4] 
			,1 as [Order]
	from ctePivotQtr
	group by [Functional Area]
			,[CCH Lvl 2 Name]
			--,[Sum_Ending_Headcount]
	--order by [Functional Area]
	--		,[CCH Lvl 2 Name]
		
	union all 

--DC subtotal
	Select 'DC' as [Functional Area]
			,'Total' as [CCH Lvl 2 Name]
			,sum(case when [Fiscal Qtr/Year]='2020-Q1' then [Sum_Ending_Headcount] end) as [2020_Q1]
			,sum(case when [Fiscal Qtr/Year]='2020-Q2' then [Sum_Ending_Headcount] end) as [2020_Q2]
			,sum(case when [Fiscal Qtr/Year]='2020-Q3' then [Sum_Ending_Headcount] end) as [2020_Q3]
			,sum(case when [Fiscal Qtr/Year]='2020-Q4' then [Sum_Ending_Headcount] end) as [2020_Q4] 
			,2 as [Order]
	from ctePivotQtr
	where [Functional Area]='DC'
	--group by [Functional Area] 

	union all 

--SM subtotal
	Select 'SM' as [Functional Area]
			,'Total' as [CCH Lvl 2 Name]
			,sum(case when [Fiscal Qtr/Year]='2020-Q1' then [Sum_Ending_Headcount] end) as [2020_Q1]
			,sum(case when [Fiscal Qtr/Year]='2020-Q2' then [Sum_Ending_Headcount] end) as [2020_Q2]
			,sum(case when [Fiscal Qtr/Year]='2020-Q3' then [Sum_Ending_Headcount] end) as [2020_Q3]
			,sum(case when [Fiscal Qtr/Year]='2020-Q4' then [Sum_Ending_Headcount] end) as [2020_Q4] 
			,3 as [Order]
	from ctePivotQtr
	where [Functional Area]='SM'
	--group by [Functional Area] 

	union all

--Grand total
	Select 'Total' as [Functional Area]
			,'Total' as [CCH Lvl 2 Name]
			,sum(case when [Fiscal Qtr/Year]='2020-Q1' then [Sum_Ending_Headcount] end) as [2020_Q1]
			,sum(case when [Fiscal Qtr/Year]='2020-Q2' then [Sum_Ending_Headcount] end) as [2020_Q2]
			,sum(case when [Fiscal Qtr/Year]='2020-Q3' then [Sum_Ending_Headcount] end) as [2020_Q3]
			,sum(case when [Fiscal Qtr/Year]='2020-Q4' then [Sum_Ending_Headcount] end) as [2020_Q4] 
			,4 as [Order]
	from ctePivotQtr) as tblFinal

order by [Order]
		,[Functional Area]
		,[CCH Lvl 2 Name]