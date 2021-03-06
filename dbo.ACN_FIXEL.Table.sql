USE [mySpaceman_datdb]
GO
/****** Object:  Table [dbo].[ACN_FIXEL]    Script Date: 2017-09-07 09:42:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ACN_FIXEL](
	[PLN_ID] [int] NOT NULL,
	[DRAW] [smallint] NULL,
	[LABEL_ON] [smallint] NULL,
	[DIM_WIDTH] [smallint] NULL,
	[DIM_ELEVATION] [smallint] NULL,
	[FILL_COLOR] [smallint] NULL,
	[FIXEL_ID] [nvarchar](255) NOT NULL,
	[FIXEL_NAME] [nvarchar](255) NULL,
	[MANUFACTURER] [nvarchar](255) NULL,
	[TYPE] [smallint] NULL,
	[BASKET_FILL] [smallint] NULL,
	[OCCUPANCY] [smallint] NULL,
	[ROTATION] [smallint] NULL,
	[SLOPE] [smallint] NULL,
	[NOTCH_POSITION] [smallint] NULL,
	[X] [float] NULL,
	[Y] [float] NULL,
	[Z] [float] NULL,
	[HEIGHT] [float] NULL,
	[WIDTH] [float] NULL,
	[DEPTH] [float] NULL,
	[THICKNESS] [float] NULL,
	[HORIZ_SPACING] [float] NULL,
	[VERT_SPACING] [float] NULL,
	[GRILL_HEIGHT] [float] NULL,
	[GRILL_SLOPE] [float] NULL,
	[MAX_MERCH] [float] NULL,
	[DEP_SPACING] [float] NULL,
	[SP_TOP] [float] NULL,
	[FRONT] [float] NULL,
	[GRID_TYPE] [smallint] NULL,
	[ASSEMBLY] [nvarchar](255) NULL,
	[ATTACHED_TO] [nvarchar](255) NULL,
	[HORIZ_GAP] [float] NULL,
	[SPACER_THICK] [float] NULL,
	[FINGER_SPACE] [float] NULL,
	[AVAILABLE] [float] NULL,
	[GRILL] [float] NULL,
	[MAX_HIGH] [smallint] NULL,
	[MAX_DEEP] [smallint] NULL,
	[TANGENT] [float] NULL,
	[ANGLE] [float] NULL,
	[RISE] [float] NULL,
	[PLACEMENT] [smallint] NULL,
	[NOTCH_SNAP_Y] [float] NULL,
	[FRAME_ELEMENT] [smallint] NULL,
	[SEGMENT] [smallint] NULL,
	[FIT_TYPE] [smallint] NULL,
	[LEFT_OVERHANG] [float] NULL,
	[RIGHT_OVERHANG] [float] NULL,
	[FRONT_OVERHANG] [float] NULL,
	[BACK_OVERHANG] [float] NULL,
	[UPPER_OVERHANG] [float] NULL,
	[LOWER_OVERHANG] [float] NULL,
	[COMBINE] [smallint] NULL,
	[MIN_HIGH] [smallint] NULL,
	[MIN_DEEP] [smallint] NULL,
	[TEXTFIELD] [nvarchar](255) NULL,
	[ALLOW_OVERLAP] [smallint] NULL,
	[FILL_MODE] [smallint] NULL,
	[LABEL] [nvarchar](255) NULL,
	[SPREAD_PRODUCTS] [smallint] NULL,
	[SECTION_ID] [nvarchar](255) NULL,
	[FONTID] [nvarchar](255) NULL,
	[FLIPPED] [smallint] NULL,
	[AUTO_CRUSH] [smallint] NULL,
	[COLOUR] [int] NULL,
	[COLOURISCLEAR] [smallint] NULL,
	[FILL_PATTERN] [smallint] NULL,
	[TEXTBOX_WORD_WRAP] [smallint] NULL,
	[TEXTBOX_REDUCE_TO_FIT] [smallint] NULL,
	[HORIZSLOTSTART] [float] NULL,
	[HORIZSLOTSPACING] [float] NULL,
	[DEPTHSLOTSTART] [float] NULL,
	[DEPTHSLOTSPACING] [float] NULL,
	[LOCALX] [float] NULL,
	[LOCALY] [float] NULL,
	[LOCALZ] [float] NULL,
	[SNAPTOSLOT] [smallint] NULL,
	[SLOT_ORIENTATION] [smallint] NULL,
	[FIXED] [smallint] NULL,
	[FIXTUREDISTANCE] [float] NULL,
	[TREATASSIGN] [smallint] NULL,
 CONSTRAINT [PK_ACN_FIXEL] PRIMARY KEY CLUSTERED 
(
	[PLN_ID] ASC,
	[FIXEL_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[ACN_FIXEL]  WITH NOCHECK ADD  CONSTRAINT [FK_ACN_FIXEL] FOREIGN KEY([PLN_ID])
REFERENCES [dbo].[ACN_PLANOGRAMS] ([PLN_ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ACN_FIXEL] CHECK CONSTRAINT [FK_ACN_FIXEL]
GO
