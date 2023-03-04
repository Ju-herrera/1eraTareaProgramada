CREATE PROCEDURE spAgregarArticulo
    @nombre AS VARCHAR(128),
    @precio AS MONEY,
	@msg AS VARCHAR(100) OUTPUT

AS
SET @msg = 'El Usuario ya existe.'
IF NOT EXISTS (SELECT Nombre FROM dbo.Articulo WHERE Nombre = @nombre)
	BEGIN
		INSERT INTO dbo.Articulo (Nombre, Precio) VALUES (@nombre, @precio)
		SET @msg = 'El Usuario se registro correctamente.'
	END

GO

CREATE PROCEDURE spGetTablaArticulos
AS
	SELECT A.Nombre, A.Precio FROM dbo.Articulo A
GO