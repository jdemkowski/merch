USE [mySpaceman_datdb]
GO
/****** Object:  UserDefinedFunction [dbo].[ufnHorizontalPosValv2]    Script Date: 2017-09-07 09:42:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





-- ================================================
-- Author:		Jarosław Demkowski
-- Create date: 2017-06-14 14:14
-- Description:	Oblicza wartość atrybutu horizontal
--              do insertu do tabeli ACN_POSITION
-- ================================================
CREATE FUNCTION [dbo].[ufnHorizontalPosValv2]
(
	-- Add the parameters for the function here
	@pln INT,				-- PLN_ID
	@fid NVARCHAR(255),		-- FIXEL_ID
	@pid NVARCHAR(255)		-- PRODUCT_ID
)	/* Parametry wskazują, na którym planogramie,
	na której półce, i który produkt ma mieć obliczoną
	liczbę fejsów*/ 
RETURNS INT
AS
BEGIN
	-- Obsługa NULL-ów w parametrach wejściowych
	IF @fid IS NULL OR @pid IS NULL RETURN 0;

	-- Declare the return variable here
	DECLARE @a FLOAT				-- zmienna sterująca pozostałą do wykorzystania szerokością półki
	DECLARE @tempTable TABLE		-- tymczasowa tabela zawierająca niezbędne dane dla poprawnego
	(								-- obliczenia wyniku funkcji
		[pid] NVARCHAR(255),		-- id produktu na zadanej półce @fid
		[ran] NVARCHAR(255),		-- ranking produktu na zadanej półce @fid
		[pwi] FLOAT,				-- szerokość produktu na zadanej półce @fid
		[hor] SMALLINT				-- kolummna robocza, przechowująca wyliczane wartości
	)								-- będziemy tu aktualizować dane do ostatecznego kształtu

	-- Add the T-SQL statements to compute the return value here
	SET @a = ( SELECT [AVAILABLE] FROM [dbo].[ACN_FIXEL] WHERE [PLN_ID] = @pln AND [FIXEL_ID] = @fid )

	-- wrzucam do tabeli przechowującej informacje o produktach na półce @fid
	INSERT INTO @tempTable
		  ([pid]
		  ,[ran]
		  ,[pwi]
		  ,[hor])
	SELECT [ppl].[PRODUCT_ID]
		  ,ROW_NUMBER() OVER (ORDER BY CAST([pro].[RANK] AS INT))
		  ,[pro].[WIDTH]
		  ,0
	FROM [dbo].[ACN_FIXEL]       AS [fix]
	JOIN [dbo].[ACN_PRODUCT_PLN] AS [ppl] ON [fix].[PLN_ID] = [ppl].[PLN_ID] AND [fix].[FIXEL_ID] = [ppl].[PREFERRED_FIXEL]
	JOIN [dbo].[ACN_PRODUCT]	 AS [pro] ON [ppl].[PRODUCT_ID] = [pro].[PRODUCT_ID]
	WHERE  [fix].[PLN_ID] = @pln
	AND  [fix].[FIXEL_ID] = @fid
	-- 2017-06-27: dołożyłem warunek
	--AND  [pro].[HEIGHT] <= [fix].[MAX_MERCH]

	-- zmienne sterujące pętlą
	DECLARE @i SMALLINT
	DECLARE @j SMALLINT
	DECLARE @max SMALLINT  = ( SELECT MAX( CAST([ran] AS int) ) FROM @tempTable )
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

	RETURN ( SELECT [hor] FROM @tempTable WHERE [pid] = @pid )

END








GO
