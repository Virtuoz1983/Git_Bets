USE [OlAP_Analysis]
GO

/****** Object:  Table [dbo].[DimBetResult]    Script Date: 12/9/2013 2:46:13 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DimBetResult](
	[BetResultKey] [int] NOT NULL,
	[BetResultName] [nvarchar](10) NULL,
 CONSTRAINT [PK_DimBetResult] PRIMARY KEY CLUSTERED 
(
	[BetResultKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


