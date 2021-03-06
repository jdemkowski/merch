USE [mySpaceman_datdb]
GO
/****** Object:  StoredProcedure [dbo].[delProducts]    Script Date: 2017-09-07 09:42:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*------------------------------------------------------------------------------------------------*/
/* Stored procedure 1 for updating generic product table - [ACN_PRODUCT]                          */
/*                                                                                                */
/* Script Date: 22 lutego 2016 12:03:46                                                           */
/*------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[delProducts]
@Dummy VarChar(1) = '%'
AS 
DELETE  FROM [ACN_PRODUCT] WHERE ([ACN_PRODUCT].[Product_Id] IN (SELECT [ACN_T_PRODUCT].[Product_Id] FROM [ACN_T_PRODUCT]))

GO
