CREATE PROCEDURE [dbo].[GetProductChangesByRowVersion](
   @startRow BIGINT 
   ,@endRow  BIGINT 
)
AS
BEGIN
  SET NOCOUNT ON;

  SELECT 
       p.[ProductID]
      ,p.[ProductName]
      ,s.[CompanyName] AS [SupplierName] -- Le damos un alias claro para el DW
      ,c.[CategoryName]
      ,p.[QuantityPerUnit]
      ,p.[UnitPrice]
      ,p.[UnitsInStock]
      ,p.[UnitsOnOrder]
      ,p.[ReorderLevel]
      ,p.[Discontinued]
      ,p.[rowversion] -- Siempre incluimos el rowversion para el mapeo
  FROM [dbo].[Products] p
	LEFT JOIN [dbo].[Categories] c ON p.CategoryID = c.CategoryID
	LEFT JOIN [dbo].[Suppliers] s ON p.SupplierID = s.SupplierID
  WHERE 
     (p.[rowversion] > CONVERT(ROWVERSION, @startRow) AND p.[rowversion] <= CONVERT(ROWVERSION, @endRow))
	OR (c.[rowversion] > CONVERT(ROWVERSION, @startRow)	AND c.[rowversion] <= CONVERT(ROWVERSION, @endRow))
	OR (s.[rowversion] > CONVERT(ROWVERSION, @startRow) AND s.[rowversion] <= CONVERT(ROWVERSION, @endRow));
END
GO