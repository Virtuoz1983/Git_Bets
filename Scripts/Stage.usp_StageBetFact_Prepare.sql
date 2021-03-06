USE [OlAP_Analysis]
GO
/****** Object:  StoredProcedure [Stage].[usp_StageBetFact_Prepare]    Script Date: 4/1/2014 11:37:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [Stage].[usp_StageBetFact_Prepare] 
AS
BEGIN

    -- update date from russian month names to english names
	update Stage.FactBet
	   SET DateTimeMatch = case when charindex(N'дек',DateTimeMatch) != 0 then replace(DateTimeMatch,N'дек','dec') 
	                            when charindex(N'ноя',DateTimeMatch) != 0 then replace(DateTimeMatch,N'ноя','nov') 
								when charindex(N'окт',DateTimeMatch) != 0 then replace(DateTimeMatch,N'окт','oct') 
								when charindex(N'сен',DateTimeMatch) != 0 then replace(DateTimeMatch,N'сен','sep') 
								when charindex(N'авг',DateTimeMatch) != 0 then replace(DateTimeMatch,N'авг','aug') 
								when charindex(N'июл',DateTimeMatch) != 0 then replace(DateTimeMatch,N'июл','jul') 
								when charindex(N'июн',DateTimeMatch) != 0 then replace(DateTimeMatch,N'июн','jun') 
								when charindex(N'май',DateTimeMatch) != 0 then replace(DateTimeMatch,N'май','may') 
								when charindex(N'апр',DateTimeMatch) != 0 then replace(DateTimeMatch,N'апр','apr') 
								when charindex(N'мар',DateTimeMatch) != 0 then replace(DateTimeMatch,N'мар','mar') 
								when charindex(N'фев',DateTimeMatch) != 0 then replace(DateTimeMatch,N'фев','feb') 
								when charindex(N'янв',DateTimeMatch) != 0 then replace(DateTimeMatch,N'янв','jan') 
                           else DateTimeMatch end
	   
	-- update other fields
	UPDATE Stage.FactBet
	SET	  
	      -- FK keys link
		  Koef           = rtrim(ltrim(Koef)),
		  BetResultKey   = TBetRes.BetResultKey,
		  ChampKey       = TChamp.ChampKey,
		  DateBetKey     = TDateBet.DateKey,
		  DateMatchKey   = TDateMatch.DateKey,
		  TimeBetKey     = TTimeBet.TimeKey,
		  TimeMatchKey   = TTimeMatch.TimeKey,
		  KindOfSportKey = TKindSport.KindOfSportKey,
		  ResultKey      = TResult.ResultKey
	  FROM	 Stage.FactBet				AS Tbets 
				LEFT JOIN dbo.DimBetResult		AS TBetRes	  ON Tbets.BetResult  		             = TBetRes.BetResultName
				LEFT JOIN dbo.DimChamp          AS TChamp     ON replace(Tbets.Champ,' ','')         like N'%'+TChamp.ChampName+'%'
				--LEFT JOIN dbo.DimChamp          AS TChamp     ON Tbets.Champ                       = TChamp.ChampName
				LEFT JOIN dbo.DimDate           AS TDateBet   ON convert(date,Tbets.DateTimeBet,103) = TDateBet.FullDateAlternateKey
				LEFT JOIN dbo.DimDate           AS TDateMatch ON convert(date,Tbets.DateTimeMatch)   = TDateMatch.FullDateAlternateKey
				LEFT JOIN dbo.DimTime           AS TTimeBet   ON convert(time,Tbets.DateTimeBet,103) = TTimeBet.FullTimeAlternateKey
				LEFT JOIN dbo.DimTime           AS TTimeMatch ON convert(time,Tbets.DateTimeMatch)   = TTimeMatch.FullTimeAlternateKey
				LEFT JOIN dbo.DimKindOfSport    AS TKindSport ON TBets.KindOfSport                   = TKindSport.KindOfSportName
				LEFT JOIN dbo.DimResult         AS TResult    ON replace(TBets.Result,' ','')        = TResult.ResultName		

		  
	 -- update BetResultKey
		  -- remove duplicates
		  ;WITH CTE
		  AS
		   ( 
		     SELECT ROW_NUMBER() OVER(PARTITION BY DateBetKey, TimeBetKey, DateMatchKey, TimeMatchKey, ChampKey, MatchName ORDER BY DateBetKey,TimeBetKey ASC) AS rn
		     FROM Stage.FactBet
		   )
		   DELETE CTE
		   WHERE rn != 1;

	    DELETE FROM Stage.FactBet
     	where DateBetKey is null;
END
