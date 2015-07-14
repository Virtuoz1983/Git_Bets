USE [OlAP_Analysis]
GO

/****** Object:  Table [Stage].[FactBet]    Script Date: 12/9/2013 4:15:09 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Stage].[FactBet](
	[BetID] [int] IDENTITY(1,1) NOT NULL,
	[DateTimeBet] [varchar](50) NOT NULL,
	[DateTimeMatch] [varchar](50) NOT NULL,
	[KindOfSport] [nvarchar](300) NOT NULL,
	[Champ] [nvarchar](1000) NOT NULL,
	[Result] [nvarchar](100) NOT NULL,
	[BetResult] [nvarchar](10) NOT NULL,
	[MatchName] [nvarchar](350) NOT NULL,
	[ResultName] [nvarchar](150) NOT NULL,
	[RealResult] [nvarchar](50) NOT NULL,
	[Koef] [varchar](10) NOT NULL,
 	[BetResultKey] [int] NULL,
	[ChampKey] [int] NULL,
	[DateBetKey] [int] NULL,
	[DateMatchKey] [int] NULL,
	[TimeBetKey] [int] NULL,
	[TimeMatchKey] [int] NULL,
	[KindOfSportKey] [int] NULL,
	[ResultKey] [int] NULL
 CONSTRAINT [PK_StageFactBet] PRIMARY KEY CLUSTERED 
(
	[BetID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


