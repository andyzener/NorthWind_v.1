CREATE PROCEDURE [dbo].[GetOrderChangesByRowVersion](
   @startRow BIGINT 
   ,@endRow  BIGINT 
)
AS
BEGIN
  SET NOCOUNT ON;

  SELECT 
       o.[OrderID]
      ,d.[ProductID]
      ,o.[CustomerID]
      ,o.[EmployeeID]
      ,o.[OrderDate]
      ,o.[RequiredDate]
      ,o.[ShippedDate]
      ,o.[ShipVia] -- Para la dimensión de Transportistas
      ,d.[UnitPrice]
      ,d.[Quantity]
      ,d.[Discount]
      ,o.[rowversion] AS [OrderRV]
      ,d.[rowversion] AS [DetailRV]
  FROM [dbo].[Orders] o
  INNER JOIN [dbo].[Order Details] d ON o.OrderID = d.OrderID
  WHERE 
     (o.[rowversion] > CONVERT(ROWVERSION, @startRow) AND o.[rowversion] <= CONVERT(ROWVERSION, @endRow))
  OR (d.[rowversion] > CONVERT(ROWVERSION, @startRow) AND d.[rowversion] <= CONVERT(ROWVERSION, @endRow));
END
GO