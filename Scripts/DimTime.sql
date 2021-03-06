USE [OlAP_Analysis]
GO

/****** Object:  Table [dbo].[DimTime]    Script Date: 12/9/2013 2:48:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[DimTime](
	[TimeKey] [int] NOT NULL,
	[FullTimeAlternateKey] [time](0) NOT NULL,
	[Time24] [varchar](8) NOT NULL,
	[HourNumber] [tinyint] NOT NULL,
	[MinuteNumber] [tinyint] NOT NULL,
	[AMPM] [char](2) NOT NULL,
 CONSTRAINT [PK_DimTime_TimeKey] PRIMARY KEY CLUSTERED 
(
	[TimeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [AK_DimTime_FullTimeAlternateKey] UNIQUE NONCLUSTERED 
(
	[FullTimeAlternateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


