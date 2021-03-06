USE [mySpaceman_datdb]
GO
/****** Object:  Table [dbo].[ACN_FONT]    Script Date: 2017-09-07 09:42:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ACN_FONT](
	[PLN_ID] [int] NOT NULL,
	[COLLECTION_ID] [nvarchar](255) NULL,
	[BOLD] [smallint] NULL,
	[CHARSET] [smallint] NULL,
	[ITALIC] [smallint] NULL,
	[FONT_NAME] [nvarchar](255) NULL,
	[SIZE_VAL] [float] NULL,
	[STRIKETHROUGH] [smallint] NULL,
	[UNDERLINE] [smallint] NULL,
	[WEIGHT] [smallint] NULL,
	[COLOUR] [smallint] NULL
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[ACN_FONT]  WITH NOCHECK ADD  CONSTRAINT [FK_ACN_FONT] FOREIGN KEY([PLN_ID])
REFERENCES [dbo].[ACN_PLANOGRAMS] ([PLN_ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ACN_FONT] CHECK CONSTRAINT [FK_ACN_FONT]
GO
