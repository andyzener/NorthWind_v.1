CREATE PROCEDURE [dbo].[GetDatabaseRowVersion]
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON;

    -- Usamos BIGINT para que sea compatible con las variables de SSIS fácilmente
    SELECT CONVERT(BIGINT, MIN_ACTIVE_ROWVERSION()) - 1 AS CurrentRowVersion;
END
GO