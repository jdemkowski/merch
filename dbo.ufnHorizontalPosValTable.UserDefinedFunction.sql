USE [mySpaceman_datdb]
GO
/****** Object:  UserDefinedFunction [dbo].[ufnHorizontalPosValTable]    Script Date: 2017-09-07 09:42:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jarosław Demkowski
-- Create date: 2017-06-14
-- Description:	Zwaraca tabelę rokładu fejsów na półce.
-- =============================================
CREATE FUNCTION [dbo].[ufnHorizontalPosValTable] 
(
	-- Add the parameters for the function here
	@pln INT,				-- PLN_ID
	@fid NVARCHAR(255),		-- FIXEL_ID
	@pid NVARCHAR(255)		-- PRODUCT_ID
)	/* Parametry wskazują, na którym planogramie,
	na której półce, i który produkt ma mieć obliczoną
	liczbę fejsów*/ 

RETURNS @tempTable TABLE
	(
		[pid] NVARCHAR(255),
		[ran] NVARCHAR(255),
		[pwi] FLOAT,
		[hor] SMALLINT
	)
AS
BEGIN
	-- Fill the table variable with the rows for your result set
	-- zmienna sterująca pętlą - steruje szerokością półki @fid
	DECLARE @a FLOAT

	SET @a = ( SELECT [AVAILABLE] FROM [dbo].[ACN_FIXEL] WHERE [PLN_ID] = @pln AND [FIXEL_ID] = @fid )
	-- wrzucamy aktualne dane o rozkładzie produktów na półce do tabeli wynikowej
	INSERT INTO @tempTable  -- tabelę wynikową będziemy aktualizować w pętli poniżej
		  ([pid]			-- id produktów na półce @fid
		  ,[ran]			-- ranking produktów na półce @fid
		  ,[pwi]			-- szerokości produktów na półce @fid
		  ,[hor])			-- aktualny rozkład produktów na pustej (!) półce
	SELECT [ppl].[PRODUCT_ID]
		  ,ROW_NUMBER() OVER (ORDER BY CAST([pro].[RANK] AS int))
		  ,[pro].[WIDTH]
		  ,0
	FROM [dbo].[ACN_FIXEL]       AS [fix]
	JOIN [dbo].[ACN_PRODUCT_PLN] AS [ppl] ON [fix].[PLN_ID] = [ppl].[PLN_ID] AND [fix].[FIXEL_ID] = [ppl].[PREFERRED_FIXEL]
	JOIN [dbo].[ACN_PRODUCT]	   AS [pro] ON [ppl].[PRODUCT_ID] = [pro].[PRODUCT_ID]
	WHERE  [fix].[PLN_ID] = @pln
	AND  [fix].[FIXEL_ID] = @fid

	-- zmienne sterujące pętlą
	DECLARE @i SMALLINT
	DECLARE @j SMALLINT
	DECLARE @max SMALLINT  = ( SELECT MAX( [ran] ) FROM @tempTable )
	DECLARE @min_pwi FLOAT = ( SELECT MIN( [pwi] ) FROM @tempTable )
	DECLARE @q SMALLINT
	DECLARE @d FLOAT

	SET @i = @max

	WHILE @a >= @min_pwi
		BEGIN
			SET @i += -1
			SET @j = 1
			WHILE @i + @j <= @max
				BEGIN
					SET @d = ( SELECT SUM( [pwi] ) FROM @tempTable WHERE [ran] BETWEEN 1 AND @i OR [ran] = @i + @j )
					IF  @d <= @a
					BEGIN
						SET @q = FLOOR( @a / @d )
						UPDATE @tempTable SET [hor] = [hor] + @q WHERE [ran] BETWEEN 1 AND @i OR [ran] = @i + @j
						SET @a +=  - @q * @d
					END
					IF @a < @min_pwi BREAK
					SET @j += 1
				END
		END
	
	RETURN 
END


GO
