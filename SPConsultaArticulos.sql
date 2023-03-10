CREATE PROCEDURE spGetTablaArticulos

AS
    SET NOCOUNT ON;
	SELECT A.Nombre, A.Precio 
	FROM dbo.Articulo A 
	ORDER BY A.Nombre ASC
GO
