USE [mySpaceman_datdb]
GO

DECLARE @RC int
DECLARE @wersja_in nvarchar(255)
DECLARE @wersja_out nvarchar(255)
DECLARE @data_start nvarchar(255)
DECLARE @data_stop nvarchar(255)

-- TODO: Set parameter values here.
SET @wersja_in = N'00 0000 V0'
SET @wersja_out = N'00 0000 V0'
SET @data_start = N'0000-00-00'
SET @data_stop = N'0000-00-00'

EXECUTE @RC = [dbo].[uspWersjonowaniePLNv3] 
   @wersja_in
  ,@wersja_out
  ,@data_start
  ,@data_stop
GO


