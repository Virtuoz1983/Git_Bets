USE [OlAP_Analysis]
GO

/****** Object:  Table [dbo].[DimKindOfSport]    Script Date: 12/9/2013 2:47:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DimKindOfSport](
	[KindOfSportKey] [int] NOT NULL,
	[KindOfSportName] [nvarchar](50) NULL,
 CONSTRAINT [PK_DimKindOfSport] PRIMARY KEY CLUSTERED 
(
	[KindOfSportKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


