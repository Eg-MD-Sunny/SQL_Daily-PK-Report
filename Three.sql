------Daily Agent Wise Calls Report  

SELECT CAST(egg1.dbo.tobdt(CEL.Date) AS DATE) Date,
PKE.ChaldalBadgeId,
PKE.ChaldalUserName,
COUNT(*) TotalCallCount,
SUM(CASE WHEN CEL.Status = 'Picked' THEN 1 ELSE 0 END)+SUM(CASE WHEN CEL.Action = 'IncomingCall' THEN 1 ELSE 0 END) TotalReceivedCall,
SUM(CASE WHEN CEL.Status = 'DidNotPick' THEN 1 ELSE 0 END) FailedCallCount

FROM pk.Employee PKE
INNER JOIN pk.CustomerEventLog CEL ON PKE.UserId=CEL.EventCreatedBy
Where CAST(egg1.dbo.tobdt(CEL.Date) AS DATE) = '2022-06-20'

GROUP BY	CAST(egg1.dbo.tobdt(CEL.Date) AS DATE),
			PKE.ChaldalBadgeId,
			PKE.ChaldalUserName