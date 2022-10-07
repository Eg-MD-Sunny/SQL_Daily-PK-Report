------Daily Group Wise Sales Report      

SELECT	CAST(egg1.dbo.tobdt(O.CreatedOnUtc) AS DATE) OrderCreatedOn,
		PKG.Name [Group],
		COUNT(DISTINCT PKE.UserId) GroupEmployee,
		COUNT(DISTINCT(PKC.ChaldalCustomerId)) CustomerCount,
		COUNT(DISTINCT(O.Id)) TotalOrderPlaced, COUNT(DISTINCT ( CASE WHEN S.ReconciledOn  >= '2022-06-16 00:00 +6:00' AND S.ReconciledOn < '2022-06-17 00:00 +6:00' AND S.ReconciledOn is not null THEN o.id ELSE NULL END)) ReconciledOrders,
		SUM(TR.Saleprice) TotalSales, SUM(TR.Saleprice)/COUNT(DISTINCT(O.Id)) [Per Order Value]

FROM pk.Customer PKC
INNER JOIN egg1.dbo.Customer CC ON CC.Id=PKC.ChaldalCustomerId
INNER JOIN pk.Employee PKE ON PKE.UserId = PKC.AssignedTo
INNER JOIN pk.[Group] PKG ON PKG.Id = PKC.GroupId
INNER JOIN egg1.dbo.[order] O ON O.CustomerId=CC.Id
INNER JOIN egg1.dbo.Shipment S ON S.OrderId=O.Id
INNER JOIN egg1.dbo.ThingRequest TR ON TR.ShipmentId=S.Id

WHERE   CAST(egg1.dbo.tobdt(O.CreatedOnUtc) AS DATE)  >= '2022-06-16'
AND    CAST(egg1.dbo.tobdt(O.CreatedOnUtc) AS DATE) < '2022-06-17'
AND     O.OrderStatus <> 40

GROUP BY	CAST(egg1.dbo.tobdt(O.CreatedOnUtc) AS DATE),
			PKG.Name