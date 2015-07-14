USE [OlAP_Analysis]
GO

/****** Object:  Table [dbo].[FactBet]    Script Date: 12/9/2013 2:48:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[FactBet](
	[DateBetKey] [int] NOT NULL,
	[TimeBetKey] [int] NOT NULL,
	[DateMatchKey] [int] NOT NULL,
	[TimeMatchKey] [int] NOT NULL,
	[KindOfSportKey] [int] NOT NULL,
	[ChampKey] [int] NOT NULL,
	[ResultKey] [int] NOT NULL,
	[BetResultKey] [int] NOT NULL,
	[MatchName] [nvarchar](350) NOT NULL,
	[ResultName] [nvarchar](150) NOT NULL,
	[RealResult] [nvarchar](50) NOT NULL,
	[Koef] [float] NOT NULL,
 CONSTRAINT [PK_FactBet] PRIMARY KEY CLUSTERED 
(
	[DateBetKey] ASC,
	[TimeBetKey] ASC,
	[ChampKey] ASC,
	[ResultKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[FactBet]  WITH CHECK ADD  CONSTRAINT [FK_FactBet_DimBetResult] FOREIGN KEY([BetResultKey])
REFERENCES [dbo].[DimBetResult] ([BetResultKey])
GO

ALTER TABLE [dbo].[FactBet] CHECK CONSTRAINT [FK_FactBet_DimBetResult]
GO

ALTER TABLE [dbo].[FactBet]  WITH CHECK ADD  CONSTRAINT [FK_FactBet_DimChamp] FOREIGN KEY([ChampKey])
REFERENCES [dbo].[DimChamp] ([ChampKey])
GO

ALTER TABLE [dbo].[FactBet] CHECK CONSTRAINT [FK_FactBet_DimChamp]
GO

ALTER TABLE [dbo].[FactBet]  WITH CHECK ADD  CONSTRAINT [FK_FactBet_DimDate_BetDate] FOREIGN KEY([DateBetKey])
REFERENCES [dbo].[DimDate] ([DateKey])
GO

ALTER TABLE [dbo].[FactBet] CHECK CONSTRAINT [FK_FactBet_DimDate_BetDate]
GO

ALTER TABLE [dbo].[FactBet]  WITH CHECK ADD  CONSTRAINT [FK_FactBet_DimDate_MatchDate] FOREIGN KEY([DateMatchKey])
REFERENCES [dbo].[DimDate] ([DateKey])
GO

ALTER TABLE [dbo].[FactBet] CHECK CONSTRAINT [FK_FactBet_DimDate_MatchDate]
GO

ALTER TABLE [dbo].[FactBet]  WITH CHECK ADD  CONSTRAINT [FK_FactBet_DimKindOfSport] FOREIGN KEY([KindOfSportKey])
REFERENCES [dbo].[DimKindOfSport] ([KindOfSportKey])
GO

ALTER TABLE [dbo].[FactBet] CHECK CONSTRAINT [FK_FactBet_DimKindOfSport]
GO

ALTER TABLE [dbo].[FactBet]  WITH CHECK ADD  CONSTRAINT [FK_FactBet_DimResult] FOREIGN KEY([ResultKey])
REFERENCES [dbo].[DimResult] ([ResultKey])
GO

ALTER TABLE [dbo].[FactBet] CHECK CONSTRAINT [FK_FactBet_DimResult]
GO

ALTER TABLE [dbo].[FactBet]  WITH CHECK ADD  CONSTRAINT [FK_FactBet_DimTime_BetTime] FOREIGN KEY([TimeBetKey])
REFERENCES [dbo].[DimTime] ([TimeKey])
GO

ALTER TABLE [dbo].[FactBet] CHECK CONSTRAINT [FK_FactBet_DimTime_BetTime]
GO

ALTER TABLE [dbo].[FactBet]  WITH CHECK ADD  CONSTRAINT [FK_FactBet_DimTime_MatchTime] FOREIGN KEY([TimeMatchKey])
REFERENCES [dbo].[DimTime] ([TimeKey])
GO

ALTER TABLE [dbo].[FactBet] CHECK CONSTRAINT [FK_FactBet_DimTime_MatchTime]
GO


