USE [mySpaceman_datdb]
GO
/****** Object:  StoredProcedure [dbo].[uspPozycjeNaPolkiLocal]    Script Date: 2017-09-07 09:42:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:		Jarosław Demkowski
-- Create date: 2017-07-21
-- Description:	Auto Fill + Proportionall Fill
-- na zadany id zakres pln w zadanej wersji pln
-- =============================================
CREATE PROCEDURE [dbo].[uspPozycjeNaPolkiLocal]

	@wersja nvarchar(255),
	@id_poczatek int,
	@id_koniec int

AS
BEGIN

SET NOCOUNT ON;

BEGIN TRANSACTION;
 
BEGIN TRY

UPDATE [dbo].[ACN_FIXEL]
SET [SPREAD_PRODUCTS]=0
FROM [dbo].[ACN_FIXEL] AS [fix]
JOIN [dbo].[ACN_PRODUCT_PLN] AS [ppl] ON [fix].[PLN_ID] = [ppl].[PLN_ID] AND [fix].[FIXEL_ID] = [ppl].[PREFERRED_FIXEL]
JOIN [dbo].[ACN_PRODUCT] AS [pro] ON [ppl].[PRODUCT_ID] = [pro].[PRODUCT_ID]
WHERE [pro].[HEIGHT]>[fix].[MAX_MERCH] AND [fix].[PLN_ID] BETWEEN @id_poczatek AND @id_koniec;

WITH [cteMergedData]
AS
(
	SELECT
		 [fix].[PLN_ID] AS [pid]
		,[fix].[SECTION_ID] AS [sid]
		,[fix].[SEGMENT] AS [seg]
		,[fix].[FIXEL_ID] AS [fid]
		,[fix].[X] AS [fix]
		,[fix].[Y] AS [fiy]
		,[fix].[Z] AS [fiz]
		,[fix].[HEIGHT] AS [fhe]
		,[fix].[WIDTH] AS [fwi]
		,[fix].[DEPTH] AS [fde]
		,[fix].[MAX_MERCH] AS [mxm]
		,[fix].[AVAILABLE] AS [ava]
		,[fix].[LEFT_OVERHANG] AS [lov]
		,[fix].[RIGHT_OVERHANG] AS [rov]
		,[pro].[CATEGORY] AS [cat]
		,[pro].[SUBCATEGORY] AS [sub]
		,[pro].[KEY_VAL] AS [key]
		,[pro].[DESC_A] AS [nid]
		,[pro].[DESC_C] AS [var]
		,[pro].[PRODUCT_ID] AS [prd]
		,[pro].[RANK] AS [ran]
		,[pro].[HEIGHT] AS [phe]
		,[pro].[WIDTH] AS [pwi]
		,[pro].[DEPTH] AS [pde]
		,[pro].[VERT_NEST] AS [vne]
		,[pro].[HORIZ_NEST] AS [hne]
		,[pro].[STD_ORIENT] AS [sto]
		,[pro].[MAX_HIGH] AS [pxh]
		,[pro].[MAX_DEEP] AS [pxd]
		,[pro].[MAX_HORIZ_CRUSH] AS [xhc]
		,[pro].[MAX_VERT_CRUSH] AS [xvc]
		,[pro].[MAX_DEPTH_CRUSH] AS [xdc]
		 -- Przekształcenia LVL-1
		,CASE WHEN FLOOR([fix].[DEPTH]/[pro].[DEPTH])>[pro].[MAX_DEEP]
			THEN [pro].[MAX_DEEP]
			ELSE FLOOR([fix].[DEPTH]/[pro].[DEPTH])
		 END AS [dep]
		,CASE WHEN FLOOR([fix].[MAX_MERCH]/[pro].[HEIGHT])>[pro].[MAX_HIGH]
			THEN [pro].[MAX_HIGH]
			ELSE FLOOR([fix].[MAX_MERCH]/[pro].[HEIGHT])
		 END AS [ver]
		,[dbo].[ufnHorizontalPosValv2]([fix].[PLN_ID],[fix].[FIXEL_ID],[pro].[PRODUCT_ID]) AS [hor]

	FROM [dbo].[ACN_PLANOGRAMS] AS [pln]
	JOIN [dbo].[ACN_PRODUCT_PLN] AS [ppl] ON [pln].[PLN_ID]=[ppl].[PLN_ID]
	JOIN [dbo].[ACN_FIXEL] AS [fix] ON [ppl].[PLN_ID]=[fix].[PLN_ID] AND [ppl].[PREFERRED_FIXEL]=[fix].[FIXEL_ID]
	JOIN [dbo].[ACN_PRODUCT] AS [pro] ON [ppl].[PRODUCT_ID]=[pro].[PRODUCT_ID]

	WHERE [pln].[WERSJA_PLANOGRAMU]=@wersja
	AND [fix].[PLN_ID] BETWEEN @id_poczatek AND @id_koniec --tymczasowe kryt. na okrojenie wyników zapytania
	AND [fix].[FIXEL_ID] = N'1 /wit. i supl. I'
						/*LIKE N'[1-5] /promocje'
	OR [fix].[FIXEL_ID] LIKE N'[1-5] /preparaty sezonowe'
	OR [fix].[FIXEL_ID] LIKE N'[1-6] /b[oó]l i gor[aą]czka'
	OR [fix].[FIXEL_ID] LIKE N'[1-6] /przezi[eę]bienie'
	OR [fix].[FIXEL_ID] LIKE N'[1-6] /kaszel i gard[lł]o'
	OR [fix].[FIXEL_ID] LIKE N'[1-6] /trawienie'
	OR [fix].[FIXEL_ID] LIKE N'[1-6] /wit. i supl. I'
	OR [fix].[FIXEL_ID] LIKE N'[1-6] /wit. i supl. II'
	OR [fix].[FIXEL_ID] LIKE N'[1-6] /wit. i supl. III'
	OR [fix].[FIXEL_ID] LIKE N'[1-6] /dermokosmetyki')*/
	AND [pro].[HEIGHT]<=[fix].[MAX_MERCH]
	AND [pro].[WIDTH]<=[fix].[AVAILABLE]
	AND [pro].[DEPTH]<=[fix].[DEPTH]
)
,[ctePosCalc] -- Przekształcenia LVL-2
AS
(
	SELECT
		 pid
		,fid
		,prd
		 -- szeregowanie półek po segmencie rosnąco, tj. od lewej do prawej, następnie po id półki malejąco,
		 -- tj. od położonej najniżej do położonej najwyżej w danym segmencie
		,DENSE_RANK() OVER ( PARTITION BY [pid] ORDER BY [seg] ASC, [fid] DESC ) AS [num]
		 -- numerowanie produktów, które wejdą na półkę i staną się pozycjami, wg ich rankingu rosnąco
		 -- (Renumber Location ID's/Left to Right then Top to Bottom)
		,ROW_NUMBER() OVER ( PARTITION BY [pid], [fid] ORDER BY CAST([ran] AS int)) AS [loc]
		 -- obliczenia dla standardowej jednostki wolnej przestrzeni na półce,która będzie dzielić niewykorzystaną
		 -- przestrzeń proporcjonalnie pomiędzy wszystkie fejsy i pozycje na półce (Proportional Fill/Facings)
		,CASE WHEN (SUM([hor]) OVER ( PARTITION BY [pid], [fid] )-1)>0
			THEN ([ava]-SUM([hor]*[pwi]) OVER ( PARTITION BY [pid], [fid] ))/(SUM([hor]) OVER ( PARTITION BY [pid], [fid] )-1)
			ELSE ([ava]-SUM([hor]*[pwi]) OVER ( PARTITION BY [pid], [fid] ))/2
		 END AS [stu]
	FROM [cteMergedData]
), [cteInsertData]
AS
(
	SELECT
		 [a].[pid]
		,[b].[loc]
		,CAST([b].[num] AS nvarchar(3))+N'-'+
		(
			SELECT N'-'+CAST([c].[loc] AS nvarchar(2))
			FROM [ctePosCalc] AS [c]
			WHERE [c].[pid]=[b].[pid]
			AND [c].[num]=[b].[num]
			AND [c].[loc]<=[b].[loc]
			FOR XML PATH (N'')
		) AS [pos]
		 -- RunningSum wyliczająca współrzędną x pozycji
		,SUM([a].[hor]*([a].[pwi]+[b].[stu])) OVER ( PARTITION BY [a].[pid], [a].[fid] ORDER BY [b].[loc] ) - ([a].[hor]*([a].[pwi]+[b].[stu])) AS [x]
		,0 AS [y]
		,[a].[fde]-[a].[dep]*[a].[pde] AS [z]
		,[a].[hor] AS [tof]
		,[a].[hor]*[a].[ver]*[a].[dep] AS [tou]
		,CASE WHEN [a].[vne]=0
			THEN [a].[ver]*[a].[phe]
			ELSE ABS([a].[vne])*([a].[ver]-1)+[a].[phe]
		 END AS [vsp]
		,[a].[hor]*[a].[pwi]+[b].[stu]*([a].[hor]-1) AS [hsp]
		,[a].[dep]*[a].[pde] AS [dsp]
		,[a].[dep]
		,[a].[ver]
		,[a].[hor]
		,[a].[sid]
		,[a].[prd]
		,[a].[fid]
		,[a].[xvc]
	FROM [cteMergedData] AS [a]
	JOIN [ctePosCalc] AS [b] ON [a].[pid]=[b].[pid] AND [a].[fid]=[b].[fid] AND [a].[prd]=[b].[prd]
	WHERE [a].[hor]!=0
)
INSERT INTO [dbo].[ACN_POSITION]
	([PLN_ID]
	,[POS_ORDER]
	,[LOCATION_ID]
	,[FILL_COLOR]
	,[MERCH_STYLE]
	,[POSITION_ID]
	,[X]
	,[Y]
	,[Z]
	,[PEG_ROW]
	,[PEG_COL]
	,[PEG_ID]
	,[TOTAL_FACINGS]
	,[CAP_STYLE]
	,[TOTAL_UNITS]
	,[MAX_UNITS]
	,[SHELF_LOC]
	,[VERT_SPACE]
	,[HORIZ_SPACE]
	,[DEPTH_SPACE]
	,[DIRECTION]
	,[SLOPE]
	,[DEPTH_FACINGS]
	,[PEG]
	,[HIGHLIGHT]
	,[REQ_INV]
	,[H_REMAIN]
	,[V_REMAIN]
	,[VERTICAL]
	,[HORIZONTAL]
	,[FIT_TYPE]
	,[D_REMAIN]
	,[DEPTH_FILL]
	,[ORIENTATION]
	,[SHELF_TAGS]
	,[FIXED]
	,[SECTION_ID]
	,[PRODUCT_ID]
	,[FIXEL_ID]
	,[HORIZ_CRUSH]
	,[VERT_CRUSH]
	,[DEPTH_CRUSH]
	,[ROTATION]
	,[PEGSPREAD]
	,[COMPLEX]
	,[LEFTHORIZONTAL]
	,[LEFTVERTICAL]
	,[LEFTDEPTHFACINGS]
	,[LEFTHORIZCRUSH]
	,[LEFTVERTCRUSH]
	,[LEFTDEPTHCRUSH]
	,[LEFTORIENTATION]
	,[LEFTMERCHSTYLE]
	,[RIGHTHORIZONTAL]
	,[RIGHTVERTICAL]
	,[RIGHTDEPTHFACINGS]
	,[RIGHTHORIZCRUSH]
	,[RIGHTVERTCRUSH]
	,[RIGHTDEPTHCRUSH]
	,[RIGHTORIENTATION]
	,[RIGHTMERCHSTYLE]
	,[TOPHORIZONTAL]
	,[TOPVERTICAL]
	,[TOPDEPTHFACINGS]
	,[TOPHORIZCRUSH]
	,[TOPVERTCRUSH]
	,[TOPDEPTHCRUSH]
	,[TOPORIENTATION]
	,[TOPMERCHSTYLE]
	,[BACKHORIZONTAL]
	,[BACKVERTICAL]
	,[BACKDEPTHFACINGS]
	,[BACKHORIZCRUSH]
	,[BACKVERTCRUSH]
	,[BACKDEPTHCRUSH]
	,[BACKORIENTATION]
	,[BACKMERCHSTYLE]
	,[CONTAINERPOSITIONID]
	,[SHAREDPEGID]
	,[AUTOFILLPEG]
	,[RANKX]
	,[RANKY]
	,[RANKZ]
	,[PEGSPERFACING]
	,[TOTALPEGS])
SELECT
	 [pid]
	,0
	,[loc]
	,7
	,0
	,[pos]
	,[x]
	,[y]
	,[z]
	,0
	,0
	,N'****'
	,[tof]
	,1
	,[tou]
	,0
	,0
	,[vsp]
	,[hsp]
	,[dsp]
	,0
	,0
	,[dep]
	,0
	,0
	,0
	,0
	,0
	,[ver]
	,[hor]
	,0
	,0
	,0
	,0
	,0
	,0
	,[sid]
	,[prd]
	,[fid]
	,0
	,[xvc]
	,0
	,0
	,6
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,NULL
	,NULL
	,1
	,0
	,0
	,0
	,1
	,0
FROM [cteInsertData];

END TRY

BEGIN CATCH

SELECT ERROR_NUMBER() AS ErrorNumber
	 , ERROR_SEVERITY() AS ErrorSeverity
	 , ERROR_STATE() AS ErrorState
	 , ERROR_PROCEDURE() AS ErrorProcedure
	 , ERROR_LINE() AS ErrorLine
	 , ERROR_MESSAGE() AS ErrorMessage;

IF @@TRANCOUNT > 0
	-- wycofywanie zmian
		ROLLBACK TRANSACTION;

END CATCH;

IF @@TRANCOUNT > 0
	-- akceptacja zmian
		COMMIT TRANSACTION;-- akceptacja zmian

END









GO
