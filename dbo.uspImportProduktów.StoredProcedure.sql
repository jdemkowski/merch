USE [mySpaceman_datdb]
GO
/****** Object:  StoredProcedure [dbo].[uspImportProduktów]    Script Date: 2017-09-07 09:42:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[uspImportProduktów]

	@wersja NVARCHAR(255)

AS
BEGIN

	INSERT INTO [dbo].[ACN_PRODUCT_PLN](
		 [PLN_ID]
		,[ACTION]
		,[TIMESTAMP]
		,[LINKPRODUCTID]
		,[PRODUCT_ID]
		,[STD_PEG]
		,[OVERHANG]
		,[HORIZ_GAP]
		,[REG_MOVEMENT]
		,[PROMO_MOVEMENT]
		,[PRICE]
		,[PRICE_MULTIPLE]
		,[LOCATION_ID]
		,[PREFERRED_FIXEL]
		,[PRICE_2]
		,[PEGSPERFACING]
		)
	SELECT
		 [pln].[PLN_ID]
		,0
		,0
		,NULL
		,produkty.[Product_ID]
		,N'****'
		,0
		,0
		,0
		,0
		,produkty.[Price]
		,1
		,NULL
		,produkty.[Preferred_Fixel]
		,produkty.[Price2]
		,1
	FROM [dbo].[ACN_PLANOGRAMS] AS [pln]
	CROSS APPLY (
		SELECT
			 [Product_ID]
			,[Preferred_Fixel]
			,[Price]
			,[Price2]
		FROM [dbo].[Product$_05_2017_V1]
		WHERE [Desc_C] = @wersja AND [Category] = (
			CASE
				WHEN pln.[PLANOGRAM] like N'%[KAT][KAT][KAT]_PODSTAWOWE%' THEN N'KP'
				WHEN pln.[PLANOGRAM] like N'%[PROMO][PROMO][PROMO][PROMO][PROMO]_SEZON%' THEN N'PS'
				WHEN pln.[PLANOGRAM] like N'%DERMO%' THEN N'DK'
                ELSE N'%'
			END
		)
	) AS [produkty]
	WHERE [pln].[WERSJA_PLANOGRAMU] = @wersja

END





GO
