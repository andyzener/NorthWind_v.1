CREATE PROCEDURE [dbo].[GetCustomerChangesByRowVersion](
    @startRow BIGINT 
    ,@endRow  BIGINT 
)
AS
BEGIN
  SELECT 
     c.[CustomerID]
    ,c.[CompanyName]
    ,c.[ContactName]
    ,c.[ContactTitle]
    ,c.[Address]
    ,c.[City]
    ,c.[Region]
    ,c.[PostalCode]
    ,c.[Country]
    ,c.[Phone]
    ,c.[Fax]
    ,c.[rowversion]
    ,g.[CustomerDesc]
  FROM [dbo].[Customers] c
    -- Corregido: Unión con la tabla intermedia
    LEFT JOIN [dbo].[CustomerCustomerDemo] d ON c.CustomerID = d.CustomerID
    -- Corregido: Unión correcta entre la intermedia y la de descripción
    LEFT JOIN [dbo].[CustomerDemographics] g ON d.CustomerTypeID = g.CustomerTypeID
  WHERE 
    -- Filtro de rango para la tabla principal o sus relaciones
    (c.[rowversion] > CONVERT(ROWVERSION, @startRow) AND c.[rowversion] <= CONVERT(ROWVERSION, @endRow))
    OR (d.[rowversion] > CONVERT(ROWVERSION, @startRow) AND d.[rowversion] <= CONVERT(ROWVERSION, @endRow))
    OR (g.[rowversion] > CONVERT(ROWVERSION, @startRow) AND g.[rowversion] <= CONVERT(ROWVERSION, @endRow));
END
GO
