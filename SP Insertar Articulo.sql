
alter PROCEDURE spAgregarArticulo
    @inNombre AS VARCHAR(128)          -- Nombre de articulo
    , @inClasesdeArticulo AS INT               -- Precio
    , @inPrecio AS MONEY               -- Precio
	, @inUserId INT	                  -- Usuario persona que esta insertando desde UI
	, @inIP VARCHAR(64)               -- ip desde donde corre el UI que inserta
	, @outResultCode INT OUTPUT	      -- Codigo de resultado del SP
AS
BEGIN 
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	-- Se validan los datos de entrada, pues no estamos seguros que se validaron en capa logica.
	-- Validar que articulo exista.
	BEGIN TRY
		-- Inicia codigo en el cual se captura errores
		DECLARE @LogDescription VARCHAR(2000)= '{TipoAccion=<“Insertar articulo fallido”> Description=<' 
												+ CAST(@inClasesdeArticulo AS varchar(300)) +'><' 
												+ @inNombre +'><'
												+ CAST(@inPrecio AS varchar(300)) +'>}';
		SET @outResultCode=0;  -- Por default codigo error 0 es que no hubo error

		IF EXISTS (SELECT A.Nombre FROM dbo.Articulo A WHERE A.Nombre = @inNombre)
		BEGIN
			-- procesar error
			INSERT dbo.EventLog (
				[LogDescription]
				, [PostIdUser]
				, [PostIP]
				, [PostTime])
			VALUES (
				@LogDescription
				, @inUserId
				, @inIP
				, GETDATE())
			SET @outResultCode=50001;		-- Articulo existe
			RETURN;
		END;

		Set @LogDescription = '{TipoAccion=<“Insertar articulo Exitoso”> Description=<' 
							+ CAST(@inClasesdeArticulo AS varchar(300)) +'><' 
							+ @inNombre +'><'
							+ CAST(@inPrecio AS varchar(300)) +'>}';
		BEGIN TRANSACTION tInsertArticulo 			
			INSERT [dbo].[Articulo] (
				[IdClaseArticulo]
				,[Nombre]
				,[Precio])
			VALUES (
				@inClasesdeArticulo
				, @inNombre
				, @inPrecio
			);
			INSERT dbo.EventLog (
				[LogDescription]
				, [PostIdUser]
				, [PostIP]
				, [PostTime])
			VALUES (
				@LogDescription
				, @inUserId
				, @inIP
				, GETDATE())
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