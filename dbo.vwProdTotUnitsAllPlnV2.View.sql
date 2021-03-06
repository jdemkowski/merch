USE [mySpaceman_datdb]
GO
/****** Object:  View [dbo].[vwProdTotUnitsAllPlnV2]    Script Date: 2017-09-07 09:42:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vwProdTotUnitsAllPlnV2]
AS

SELECT [sto].[STORE_ID] AS [Kod SAP]
	,[ca].[ID Neuca]
	,[ca].[Stan min]
	,[ca].[Kategoria]
FROM ACN_PLANOGRAMS AS [pln]
JOIN ACN_STORE		AS [sto] ON [pln].[PLN_ID] = [sto].[PLN_ID]
CROSS APPLY (
	SELECT [pro].[DESC_A]
		,SUM( [pos].[TOTAL_UNITS] )
		,[pro].[CATEGORY]
	FROM [dbo].[ACN_POSITION] AS [pos]
	JOIN [dbo].[ACN_PRODUCT]  AS [pro] ON [pos].[PRODUCT_ID] = [pro].[PRODUCT_ID]
	WHERE [pln].[PLN_ID] = [pos].[PLN_ID]
	GROUP BY [pro].[DESC_A]
		,[pro].[CATEGORY]
	) AS [ca] ( [ID Neuca], [Stan min], [Kategoria] )
WHERE [pln].[WERSJA_PLANOGRAMU] = N'04 2017 V1';




GO
EXEC sys.sp_addextendedproperty @name=N'SpacemanReportName', @value=N'Stany produktów APP+' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwProdTotUnitsAllPlnV2'
GO
