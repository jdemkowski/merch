USE [mySpaceman_datdb]
GO
/****** Object:  View [dbo].[vwProdTotUnitsAllPlnV3]    Script Date: 2017-09-07 09:42:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[vwProdTotUnitsAllPlnV3]
AS

SELECT YEAR( GETDATE() )					AS [Year]
	--,DATEPART( qq, GETDATE() )			AS [Quarter]
	,3										AS [Quarter]
	,CAST([sto].[STORE_ID] AS int)			AS [PharmacyNeucaId]
	,CAST([ca].[ProductNeucaId] AS int)		AS [ProductNeucaId]
	,CAST([ca].[Quantity] AS float)			AS [Quantity]
	,1										AS [Primary_0_OrAdditional_1]
	,[pln].[DATA_START]						AS [DataOd]
	,[pln].[DATA_STOP]						AS [DataDo]
	,1										AS [PlanogramIndywidualny]
	,[ca].[Merch_Category]
FROM [dbo].[ACN_PLANOGRAMS]					AS [pln]
JOIN [dbo].[ACN_STORE] AS [sto] ON [pln].[PLN_ID] = [sto].[PLN_ID]
CROSS APPLY (
	SELECT [pro].[DESC_A]
		,SUM( [pos].[TOTAL_UNITS] )
		,[pro].[CATEGORY]
	FROM [dbo].[ACN_POSITION]	AS [pos]
	JOIN [dbo].[ACN_PRODUCT]	AS [pro] ON [pos].[PRODUCT_ID] = [pro].[PRODUCT_ID]
	WHERE [pos].[PLN_ID] = [pln].[PLN_ID]
	GROUP BY [pro].[CATEGORY], [pro].[DESC_A]
	) AS [ca] ( [ProductNeucaId], [Quantity], [Merch_Category] )
WHERE [pln].[WERSJA_PLANOGRAMU] = N'05 2017 V1'
--ORDER BY [PharmacyNeucaId] ASC
--	,[Merch_Category] DESC
--	,CAST( [ProductNeucaId] AS INT) ASC
;





GO
