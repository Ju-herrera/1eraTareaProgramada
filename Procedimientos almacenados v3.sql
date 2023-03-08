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

CREATE PROCEDURE spActualizarArticulo
    @nombre AS VARCHAR(128),
    @precio AS MONEY,
	@msg AS VARCHAR(100) OUTPUT

AS
SET @msg = 'Nombre de articulo no existe.'
IF EXISTS (SELECT A.Nombre FROM dbo.Articulo A WHERE A.Nombre = @nombre)
	BEGIN
		UPDATE dbo.Articulo 
			SET Precio = @precio
			WHERE Nombre = @nombre
		SET @msg = 'Actualizacion exitosa.'
	END

GO


CREATE PROCEDURE spBorrarArticulo
    @nombre AS VARCHAR(128),
	@msg AS VARCHAR(100) OUTPUT

AS
SET @msg = 'Nombre de articulo no existe.'
IF EXISTS (SELECT A.Nombre FROM dbo.Articulo A WHERE A.Nombre = @nombre)
	BEGIN
		DELETE FROM dbo.Articulo 
		WHERE Nombre = @nombre
		SET @msg = 'Articulo eliminado con exito.'
	END

GO


DECLARE @mensaje AS VARCHAR(100);
exec spBorrarArticulo 'Martillo2', @mensaje OUTPUT
SELECT @mensaje AS msg