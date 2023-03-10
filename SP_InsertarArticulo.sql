--USE TP1BD1
CREATE PROCEDURE spAgregarArticulo
    @inNombre AS VARCHAR(128)          -- Nombre de articulo
    , @inPrecio AS MONEY               -- Precio
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
		
		IF EXISTS (SELECT A.Nombre FROM dbo.Articulo A WHERE A.Nombre = @inNombre)
		BEGIN
			-- procesar error
			SET @outResultCode=50001;		-- Articulo existe
			RETURN;
		END;

		Set @LogDescription = 
					@LogDescription+@inNombre
					+'", Precio="'
					+CONVERT(VARCHAR, @inPrecio)+'}';
		BEGIN TRANSACTION tInsertArticulo 			
			INSERT [dbo].[Articulo] (
				[Nombre]
				, [Precio])
			VALUES (
				@inNombre
				, @inPrecio
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
			ROLLBACK TRANSACTION tInsertArticulo; -- se deshacen los cambios realizados
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

