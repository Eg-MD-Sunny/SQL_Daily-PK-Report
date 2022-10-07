------Daily Agent Wise Sales Report  

SELECT	CAST(egg1.dbo.tobdt(O.CreatedOnUtc) AS DATE) OrderCreatedOn,
		PKE.ChaldalBadgeId,
		PKE.ChaldalUserName,
		COUNT(DISTINCT(PKC.ChaldalCustomerId)) CustomerCount,
		COUNT(DISTINCT(Case when RN.Note is not null THEN (O.Id) ELSE NULL END)) [ImpersonateOrderCount],
		COUNT(DISTINCT(Case when RN.Note is null THEN (O.Id) ELSE NULL END)) [PlacedBySelfOrderCount],
		COUNT(DISTINCT(O.Id)) TotalOrder,
		COUNT(DISTINCT ( CASE WHEN S.ReconciledOn  >= concat(CAST(GETDATE()-1 as date), ' 00:00  +06:00') AND S.ReconciledOn < concat(CAST(GETDATE() as date), ' 00:00  +06:00') AND S.ReconciledOn is not null THEN o.id ELSE NULL END)) ReconciledOrders,
		
		SUM(TR.Saleprice) TotalSales,
		SUM(TR.Saleprice)/COUNT(DISTINCT(O.Id)) [Per Order Value]

FROM pk.Customer PKC
INNER JOIN egg1.dbo.Customer CC ON CC.Id=PKC.ChaldalCustomerId
INNER JOIN pk.Employee PKE ON PKE.UserId = PKC.AssignedTo
INNER JOIN egg1.dbo.[order] O ON O.CustomerId=CC.Id
INNER JOIN egg1.dbo.Shipment S ON S.OrderId=O.Id
INNER JOIN egg1.dbo.ThingRequest TR ON TR.ShipmentId=S.Id
LEFT JOIN egg1.dbo.OrderNote RN ON S.OrderId  = RN.OrderId and RN.Note like '%Order placed by an admin%'

WHERE   CAST(egg1.dbo.tobdt(O.CreatedOnUtc) AS DATE)  = CAST(GETDATE()-1 as date)
AND     O.OrderStatus <> 40

GROUP BY	CAST(egg1.dbo.tobdt(O.CreatedOnUtc) AS DATE),
			PKE.ChaldalBadgeId,
			PKE.ChaldalUserName
			order by 2


------Daily Group Wise Sales Report      

SELECT	CAST(egg1.dbo.tobdt(O.CreatedOnUtc) AS DATE) OrderCreatedOn,
		PKG.Name [Group],
		COUNT(DISTINCT PKE.UserId) GroupEmployee,
		COUNT(DISTINCT(PKC.ChaldalCustomerId)) CustomerCount,
		COUNT(DISTINCT(O.Id)) TotalOrderPlaced, COUNT(DISTINCT ( CASE WHEN S.ReconciledOn  >= concat(CAST(GETDATE()-1 as date), ' 00:00  +06:00') AND S.ReconciledOn < concat(CAST(GETDATE() as date), ' 00:00  +06:00') AND S.ReconciledOn is not null THEN o.id ELSE NULL END)) ReconciledOrders,
		SUM(TR.Saleprice) TotalSales, SUM(TR.Saleprice)/COUNT(DISTINCT(O.Id)) [Per Order Value]

FROM pk.Customer PKC
INNER JOIN egg1.dbo.Customer CC ON CC.Id=PKC.ChaldalCustomerId
INNER JOIN pk.Employee PKE ON PKE.UserId = PKC.AssignedTo
INNER JOIN pk.[Group] PKG ON PKG.Id = PKC.GroupId
INNER JOIN egg1.dbo.[order] O ON O.CustomerId=CC.Id
INNER JOIN egg1.dbo.Shipment S ON S.OrderId=O.Id
INNER JOIN egg1.dbo.ThingRequest TR ON TR.ShipmentId=S.Id

WHERE   CAST(egg1.dbo.tobdt(O.CreatedOnUtc) AS DATE) = CAST(GETDATE()-1 as date)
AND     O.OrderStatus <> 40

GROUP BY	CAST(egg1.dbo.tobdt(O.CreatedOnUtc) AS DATE),
			PKG.Name



------Daily Agent Wise Calls Report  

SELECT CAST(egg1.dbo.tobdt(CEL.Date) AS DATE) Date,
PKE.ChaldalBadgeId,
PKE.ChaldalUserName,
COUNT(*) TotalCallCount,
SUM(CASE WHEN CEL.Status = 'Picked' THEN 1 ELSE 0 END)+SUM(CASE WHEN CEL.Action = 'IncomingCall' THEN 1 ELSE 0 END) TotalReceivedCall,
SUM(CASE WHEN CEL.Status = 'DidNotPick' THEN 1 ELSE 0 END) FailedCallCount

FROM pk.Employee PKE
INNER JOIN pk.CustomerEventLog CEL ON PKE.UserId=CEL.EventCreatedBy
Where CAST(egg1.dbo.tobdt(CEL.Date) AS DATE) = CAST(GETDATE()-1 as date)

GROUP BY	CAST(egg1.dbo.tobdt(CEL.Date) AS DATE),
			PKE.ChaldalBadgeId,
			PKE.ChaldalUserName




