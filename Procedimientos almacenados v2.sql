USE ferreteria;

CREATE PROCEDURE spAgregarArticulo
    @nombre AS VARCHAR(128),
    @precio AS MONEY,
	@msg AS VARCHAR(100) OUTPUT

AS
SET @msg = 'Nombre de articulo ya existe.'
IF NOT EXISTS (SELECT A.Nombre FROM dbo.Articulo A WHERE A.Nombre = @nombre)
	BEGIN
		INSERT INTO dbo.Articulo (Nombre, Precio) VALUES (@nombre, @precio)
		SET @msg = 'inserción exitosa.'
	END

GO

CREATE PROCEDURE spGetTablaArticulos
AS
	SELECT A.Nombre, A.Precio FROM dbo.Articulo A
GO