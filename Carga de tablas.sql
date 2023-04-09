CREATE TABLE dbo.Usuario
(
id INT IDENTITY (1, 1) NOT NULL PRIMARY KEY
, UserName VARCHAR(16) NOT NULL
, Password VARCHAR (16) NOT NULL
 );
CREATE TABLE dbo.EventLog (
 Id int IDENTITY(1,1) NOT NULL PRIMARY KEY
 , LogDescription varchar(2000) NOT NULL
 , PostIdUser int NOT NULL
 , PostIP varchar(64) NOT NULL
 , PostTime datetime NOT NULL
);
 CREATE TABLE dbo.ClaseArticulo
(
id INT IDENTITY (1, 1) PRIMARY KEY
, Nombre VARCHAR(64)
);
CREATE TABLE dbo.Articulo
(
id INT IDENTITY (1, 1) PRIMARY KEY
, IdClaseArticulo INT
, Nombre VARCHAR(128) NOT NULL
, Precio MONEY NOT NULL
 ); 
 CREATE TABLE [dbo].[DBErrors](
	[ErrorID] [int] IDENTITY(1,1) PRIMARY KEY
	,[UserName] [varchar](100) NULL
	,[ErrorNumber] [int] NULL
	,[ErrorState] [int] NULL
	,[ErrorSeverity] [int] NULL
	,[ErrorLine] [int] NULL
	,[ErrorProcedure] [varchar](max) NULL
	,[ErrorMessage] [varchar](max) NULL
	,[ErrorDateTime] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[Articulo] WITH CHECK ADD CONSTRAINT
[FK_Articulo_ClaseArticulo] FOREIGN KEY([idClaseArticulo])
REFERENCES [dbo].[ClaseDeArticulo] ([id])
