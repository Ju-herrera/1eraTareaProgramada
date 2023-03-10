CREATE DATABASE TP1BD1;
USE TP1BD1;
CREATE TABLE [dbo].[Articulo]
(
	id INT IDENTITY (1, 1) PRIMARY KEY
	, Nombre VARCHAR(128) NOT NULL
	, Precio MONEY NOT NULL
 ); 

CREATE TABLE [dbo].[EventLog](
	[EventID] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL
	,[LogDescription] [varchar](2000) NULL
	,[PostIdUser] [int] NULL
	,[PostIP] [varchar](64) NULL)
GO

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
GO

