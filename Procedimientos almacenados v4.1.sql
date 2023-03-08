CREATE TABLE [dbo].[EventLog](
	[EventID] [int] IDENTITY(1,1) NOT NULL,
	[LogDescription] [varchar](2000) NULL,
	[PostIdUser] [int] NULL,
	[PostIP] [int] NULL)
GO


CREATE PROCEDURE spAgregarArticulo
    @nombre AS VARCHAR(128)          -- Nombre de articulo
    , @precio AS MONEY               -- Precio
	, @inUserId INT	                 -- Usuario persona que esta insertando desde UI
	, @inIP VARCHAR(64)              -- ip desde donde corre el UI que inserta
	, @outResultCode INT OUTPUT	     -- Codigo de resultado del SP

AS
BEGIN 
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	-- Se validan los datos de entrada, pues no estamos seguros que se validaron en capa logica.
	-- Validar que articulo exista.
	BEGIN TRY
		-- Inicia codigo en el cual se captura errores

		DECLARE @LogDescription VARCHAR(2000)='Insertando en tabla Articulo: {Nombre="'
		
		SET @outResultCode=0;  -- Por default codigo error 0 es que no hubo error
		
		IF EXISTS (SELECT A.Nombre FROM dbo.Articulo A WHERE A.Nombre = @nombre)
		BEGIN
			-- procesar error
			SET @outResultCode=50001;		-- Articulo existe
			RETURN;
		END;
		-- Se hacen otras validaciones ....

		-- se preprocesa lo que luego se actualiza, si es necesario se guarda informacion en variables o en tablas variable

		Set @LogDescription = 
					@LogDescription+@nombre
					+'", Precio="'
					+CONVERT(VARCHAR, @precio)+'}';
		BEGIN TRANSACTION tInsertArticulo 
			
			INSERT [dbo].[Articulo] (
				[Nombre]
				, [Precio])
			VALUES (
				@Nombre
				, @Precio
			);

			INSERT dbo.EventLog (
				[LogDescription]
				, [PostIdUser]
				, [PostIP])
			VALUES (
				@LogDescription
				, @inUserId
				, @inIP)

			-- salvamos en evento log el evento de actualizar el articulo
		COMMIT TRANSACTION tInsertArticulo

	END TRY
	BEGIN CATCH

		IF @@TRANCOUNT>0  -- error sucedio dentro de la transaccion
		BEGIN
			ROLLBACK TRANSACTION tUpdateArticulo; -- se deshacen los cambios realizados
		END;
		INSERT INTO dbo.DBErrors	VALUES (
			SUSER_SNAME(),
			ERROR_NUMBER(),
			ERROR_STATE(),
			ERROR_SEVERITY(),
			ERROR_LINE(),
			ERROR_PROCEDURE(),
			ERROR_MESSAGE(),
			GETDATE()
		);

		Set @outResultCode=50005;
	
	END CATCH

	SET NOCOUNT OFF;
END;

CREATE PROCEDURE spAgregarArticuloCall
    @nombre AS VARCHAR(128),
    @precio AS MONEY,
	@msg AS VARCHAR(100) OUTPUT

AS
SET @msg = 'Nombre de articulo ya existe.'
DECLARE @inUserId1 INT;	
DECLARE @inIP1 VARCHAR(64);
DECLARE @mensaje AS INT;
exec spAgregarArticulo @nombre, @precio, @inUserId1, @inIP1, @mensaje OUTPUT
IF @mensaje = 0
	BEGIN
		SET @msg = 'Inserción exitosa.'
	END

GO

CREATE PROCEDURE spGetTablaArticulos
AS
	SELECT A.Nombre, A.Precio 
	FROM dbo.Articulo A 
	ORDER BY A.Nombre ASC
GO

--forma de llamar al metodo
--DECLARE @mensaje AS VARCHAR(100);
--exec spAgregarArticuloCall 'Serrucho2', 3000.00, @mensaje OUTPUT
--SELECT @mensaje AS msg
