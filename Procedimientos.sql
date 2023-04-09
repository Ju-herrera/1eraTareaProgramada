
CREATE PROCEDURE spFiltroNombre( 
	@inEntrada varchar(240)            -- Valor el cual se va consultar
	, @inUserId INT	                   -- Usuario persona que esta insertando desde UI
	, @inIP VARCHAR(64))               -- ip desde donde corre el UI que inserta
AS
BEGIN

--Descripcion que se colocara en la tabla EventLog
DECLARE @LogDescription VARCHAR(2000)= '{TipoAccion=<“Consulta por Nombre”> Description=<'

--Entra a esta parte del codigo en caso de no recibir nada
IF (@inEntrada is null)
	SELECT a.id, Ca.Nombre, a.Nombre, a.Precio
	FROM dbo.Articulo a
	inner join ClaseArticulo Ca 
	on Ca.id = a.IdClaseArticulo
	ORDER BY a.Nombre asc

	--Añade a la descripcion del log en caso de no haber recibido nada
	SET @LogDescription =
					@LogDescription + '“”>}'

--Entra a esta parte del codigo en caso de haber recibido algo a consultar
IF (@inEntrada is not null)
	DECLARE @tex varchar(241) 
	SET @tex = '%'+@inEntrada+'%'
	SELECT a.id, Ca.Nombre, a.Nombre, a.Precio
	FROM dbo.Articulo a
	inner join ClaseArticulo Ca 
	on Ca.id = a.IdClaseArticulo 
	WHERE a.Nombre LIKE @tex

	--Añade a la descripcion del log con lo que haya recibido de entrada
	SET @LogDescription =
					@LogDescription + @inEntrada+ '>}'

--Hace el registro del movimiento en la tabla de EventLog
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
END;

CREATE PROCEDURE spFiltroPrecio( 
	@inEntrada varchar(240)            -- Valor el cual se va consultar
	, @inUserId INT	                   -- Usuario persona que esta insertando desde UI
	, @inIP VARCHAR(64))               -- ip desde donde corre el UI que inserta
AS
BEGIN

--Descripcion que se colocara en la tabla EventLog
DECLARE @LogDescription VARCHAR(2000)= '{TipoAccion=<“Consulta por cantidad”> Description=<'

IF (@inEntrada is null)
	SELECT a.id, Ca.Nombre, a.Nombre, a.Precio
	FROM dbo.Articulo a
	inner join ClaseArticulo Ca 
	on Ca.id = a.IdClaseArticulo
	ORDER BY a.Nombre asc

	--Añade a la descripcion del log en caso de no haber recibido nada
	SET @LogDescription =
					@LogDescription + '“”>}'
IF (@inEntrada is not null)
	DECLARE @teP varchar(241) 
	SET @teP = '%'+@inEntrada+'%'
	SELECT a.id, Ca.Nombre, a.Nombre, a.Precio
	FROM dbo.Articulo a
	inner join ClaseArticulo Ca 
	on Ca.id = a.IdClaseArticulo 
	WHERE Precio LIKE @teP
	ORDER BY a.Nombre asc

	--Añade a la descripcion del log con lo que haya recibido de entrada
	SET @LogDescription =
					@LogDescription + @inEntrada+ '>}'

--Hace el registro del movimiento en la tabla de EventLog
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
END;

CREATE PROCEDURE spFiltroClaseArticulo( 
	@inEntrada varchar(240)            -- Valor el cual se va consultar
	, @inUserId INT	                   -- Usuario persona que esta insertando desde UI
	, @inIP VARCHAR(64))               -- ip desde donde corre el UI que inserta
AS
BEGIN

--Descripcion que se colocara en la tabla EventLog
DECLARE @LogDescription VARCHAR(2000)= '{TipoAccion=<“Consulta por clase de articulo”> Description=<'

--En caso de no recibir nada, entra a esta parte del codigo
IF (@inEntrada is null)
	SELECT a.id, a.Nombre, Ca.Nombre, a.Precio
	FROM dbo.Articulo a
	inner join ClaseArticulo Ca 
	on Ca.id = a.IdClaseArticulo
	WHERE a.IdClaseArticulo = (SELECT TOP (1) id
							 FROM dbo.ClaseArticulo)
	ORDER BY a.Nombre asc

	--Añade a la descripcion del log en caso de no haber recibido nada
	SET @LogDescription =
					@LogDescription + '“”>}'

--En caso de haber recibido algo procede a esta parte del codigo
IF (@inEntrada is not null)
	SELECT a.id, a.Nombre, Ca.Nombre, a.Precio
	FROM dbo.Articulo a
	inner join ClaseArticulo Ca 
	on Ca.id = a.IdClaseArticulo
	WHERE a.IdClaseArticulo = (SELECT TOP (1) id
							 FROM dbo.ClaseArticulo
							 WHERE a.Nombre = @inEntrada)
	--Añade a la descripcion del log con lo que haya recibido de entrada
	SET @LogDescription =
					@LogDescription + @inEntrada+ '>}'

--Hace el registro del movimiento en la tabla de EventLog
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
END;