
CREATE PROCEDURE spIniciarSesion(
		@inUserName VARCHAR(16)           -- Usuario el cual se va a validar
		, @inPassword VARCHAR (16)        -- Contraseña del usuario el cual se va a validar
		, @inIP VARCHAR(64)               -- ip desde donde corre el UI que inserta
		, @outResultCode INT OUTPUT)       -- Codigo de resultado del SP el cual es el id del usuario
AS
BEGIN

SET @outResultCode = 0            --Se coloca en 0 en caso de que el usuario y la contraseña sea incorrecto

--Se verifica que la combinacion de usuario y contraseña existan
IF EXISTS (select *
		   from Usuario u
		   where  u.UserName = @inUserName and u.Password = @inPassword)
	--Coloca el id del usuario que se logea
	SET @outResultCode = (SELECT TOP(1) u.id
						 FROM Usuario u
						 WHERE u.UserName = @inUserName and 
							   u.Password = @inPassword)

	--Registra el proceso en la tabla de EventLog
	INSERT dbo.EventLog (
		[LogDescription]
		, [PostIdUser]
		, [PostIP]
		, [PostTime])
	VALUES (
		'{TipoAccion=<“Login exitoso”> Description=<“”>}'
		, @outResultCode
		, @inIP
		, GETDATE())
--En caso de no existir dicho usuario, pasa a esta parte del codigo
IF NOT EXISTS (select *
		   from Usuario u
		   where u.UserName = @inUserName and 
		         u.Password = @inPassword)
	--Registra el proceso en la tabla de EventLog
	INSERT dbo.EventLog (
		[LogDescription]
		, [PostIdUser]
		, [PostIP]
		, [PostTime])
	VALUES (
		'{TipoAccion=<“Login no exitoso”> Description=<“”>}'
		, @outResultCode
		, @inIP
		, GETDATE())

END
