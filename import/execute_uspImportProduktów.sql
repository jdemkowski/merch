USE [mySpaceman_datdb]
GO

DECLARE @RC int
DECLARE @wersja nvarchar(255)

-- TODO: Set parameter values here.
SET @wersja = N'0000-00-00'

EXECUTE @RC = [dbo].[uspImportProduktów] 
   @wersja
GO


