USE [mySpaceman_datdb]
GO
/****** Object:  Table [dbo].[ACN_STORE]    Script Date: 2017-09-07 09:42:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ACN_STORE](
	[PLN_ID] [int] NOT NULL,
	[STORE_ID] [nvarchar](255) NOT NULL,
	[STORE_NAME] [nvarchar](255) NULL,
	[DESC_1] [nvarchar](255) NULL,
	[DESC_2] [nvarchar](255) NULL,
	[DESC_3] [nvarchar](255) NULL,
	[DESC_4] [nvarchar](255) NULL,
	[DESC_5] [nvarchar](255) NULL,
	[DESC_6] [nvarchar](255) NULL,
	[DESC_7] [nvarchar](255) NULL,
	[FOR_LINE] [nvarchar](255) NULL,
	[BY_LINE_1] [nvarchar](255) NULL,
	[BY_LINE_2] [nvarchar](255) NULL,
	[MESSAGE_LINE_1] [nvarchar](255) NULL,
	[MESSAGE_LINE_2] [nvarchar](255) NULL,
	[MESSAGE_LINE_3] [nvarchar](255) NULL,
	[MESSAGE_LINE_4] [nvarchar](255) NULL,
	[MESSAGE_LINE_5] [nvarchar](255) NULL,
	[MESSAGE_LINE_6] [nvarchar](255) NULL,
	[MESSAGE_LINE_7] [nvarchar](255) NULL,
	[TITLE] [nvarchar](255) NULL,
	[SUBTITLE] [nvarchar](255) NULL,
	[MESSAGE_LINE_8] [nvarchar](255) NULL,
	[MESSAGE_LINE_9] [nvarchar](255) NULL,
	[MESSAGE_LINE_10] [nvarchar](255) NULL,
	[NORMALIZE_TO] [smallint] NULL,
	[CURRENCY_SYMBOL] [nvarchar](255) NULL,
	[NOTES] [nvarchar](255) NULL,
	[FILEVERSION] [nvarchar](255) NULL,
	[USINGOVERFLOWSPACE] [smallint] NULL,
	[PLANOGRAMID] [nvarchar](255) NULL,
	[PLANOGRAMTEMPLATEID] [smallint] NULL,
 CONSTRAINT [PK_ACN_STORE] PRIMARY KEY CLUSTERED 
(
	[PLN_ID] ASC,
	[STORE_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
