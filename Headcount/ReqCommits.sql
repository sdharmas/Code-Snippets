/* CQ Commit  */

select [RequisitionNumber]
     , [RequisitionTitle]
     , [HireDate_Fiscal Qtr/Year]
     , [DaysToFill]
     , [FilledDate]
     , [FirstOpenDate]
     , [HiringManagerName]
     , [LastOpenDate]
     , [ReqParentStateDesc]
     , [WorkerType]
     , [CandidateReqStatus]
     , [RecruitingStartDate]
     , [RecruitingInstruction]
     , [Cost Center]
     , [CCH Lvl 1 Name]
from [dbo].[vw_Headcount_Req_Report_Nonsensitive_Final]
where [CCH Lvl 1 Name] in ( 'David W. DMe', 'Scott B. CCP' )
      and [ReqParentStateDesc] = 'Open'
      and [HireDate_Fiscal Qtr/Year] = '2022-Q3'
      and [WorkerSubType] = 'Regular'
      and [CandidateReqStatus] in ( 'Offer', 'Background Check', 'Ready For Hire', 'Hired' )


/* NQ Commit Case 1*/

select [RequisitionNumber]
     , [RequisitionTitle]
     , [HireDate_Fiscal Qtr/Year]
     , [DaysToFill]
     , [FilledDate]
     , [FirstOpenDate]
     , [HiringManagerName]
     , [LastOpenDate]
     , [ReqParentStateDesc]
     , [WorkerType]
     , [CandidateReqStatus]
     , [RecruitingStartDate]
     , [RecruitingInstruction]
     , [Cost Center]
     , [CCH Lvl 1 Name]
from [dbo].[vw_Headcount_Req_Report_Nonsensitive_Final]
where [CCH Lvl 1 Name] in ( 'David W. DMe', 'Scott B. CCP' )
      and [ReqParentStateDesc] = 'Open'
      and [HireDate_Fiscal Qtr/Year] > '2022-Q3'
      and [WorkerSubType] = 'Regular'
      and [CandidateReqStatus] in ( 'Offer Approved', 'Offer Extended', 'Offer Accepted' )

/* NQ Commit Case 2*/

select [OfferStatusCode]
     , [CandidateReqStatus]
     , [RequisitionNumber]
     , [RequisitionTitle]
     , [HireDate_Fiscal Qtr/Year]
     , [DaysToFill]
     , [FilledDate]
     , [FirstOpenDate]
     , [HiringManagerName]
     , [LastOpenDate]
     , [ReqParentStateDesc]
     , [WorkerType]
     , [RecruitingStartDate]
     , [RecruitingInstruction]
     , [Cost Center]
     , [CCH Lvl 1 Name]
from [dbo].[vw_Headcount_Req_Report_Nonsensitive_Final]
where [CCH Lvl 1 Name] in ( 'David W. DMe', 'Scott B. CCP' )
      and [ReqParentStateDesc] = 'Open'
      and [HireDate_Fiscal Qtr/Year] > '2022-Q3'
      and [WorkerSubType] = 'Regular'
      and [CandidateReqStatus] in ( 'Background Check', 'Ready For Hire', 'Hired', 'Offer' )
      and
      (
          [OfferStatusCode] is null
          or OfferStatusCode = ''
      )