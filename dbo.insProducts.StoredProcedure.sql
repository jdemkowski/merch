USE [mySpaceman_datdb]
GO
/****** Object:  StoredProcedure [dbo].[insProducts]    Script Date: 2017-09-07 09:42:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*------------------------------------------------------------------------------------------------*/
/* Stored procedure 2 for updating generic product table - [ACN_PRODUCT]                          */
/*                                                                                                */
/* Script Date: 22 lutego 2016 12:03:46                                                           */
/*------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[insProducts]
@Dummy VarChar(1) = '%'
AS 
INSERT INTO [ACN_PRODUCT] SELECT [ACN_T_PRODUCT].* FROM [ACN_T_PRODUCT]

GO
