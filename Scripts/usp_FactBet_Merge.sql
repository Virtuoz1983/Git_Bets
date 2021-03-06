USE [OlAP_Analysis]
GO
/****** Object:  StoredProcedure [dbo].[usp_FactBet_Merge]    Script Date: 12/17/2013 10:46:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_FactBet_Merge]
AS

BEGIN

  MERGE INTO dbo.FactBet WITH (TABLOCKX) AS Tdest 
  USING 
       (
	      SELECT 
				  Tbets.DateBetKey							AS DateBetKey,                                   
		          Tbets.TimeBetKey							AS TimeBetKey,
				  Tbets.DateMatchKey						AS DateMatchKey,
				  Tbets.TimeMatchKey						AS TimeMatchKey,
				  Tbets.KindOfSportKey						AS KindOfSportKey,
				  Tbets.ChampKey							AS ChampKey,
				  Tbets.ResultKey							AS ResultKey,
				  Tbets.BetResultKey						AS BetResultKey,
				  Tbets.MatchName							AS MatchName,
				  Tbets.ResultName							AS ResultName,
				  Tbets.RealResult							AS RealResult,
				  CAST(replace(Tbets.koef,' ','') as float) AS Koef
		  FROM   Stage.FactBet				AS Tbets          
	   ) AS Tsrc ON		Tsrc.DateBetKey      = Tdest.DateBetKey
					AND Tsrc.TimeBetKey      = Tdest.TimeBetKey
					AND Tsrc.ChampKey		 = Tdest.ChampKey
					AND Tsrc.ResultKey		 = Tdest.ResultKey
					AND Tsrc.ResultName		 = Tdest.ResultName
     -- Add new bets	 
	 WHEN NOT MATCHED BY TARGET THEN
		 INSERT (
		          DateBetKey, TimeBetKey, DateMatchKey, TimeMatchKey, KindOfSportKey, ChampKey,
		          ResultKey, BetResultKey,  MatchName, ResultName, RealResult, Koef
				)				  
		 VALUES (
		          DateBetKey, TimeBetKey, DateMatchKey, TimeMatchKey, KindOfSportKey, ChampKey,
		          ResultKey, BetResultKey,  MatchName, ResultName, RealResult, Koef
				)
     -- update facts	 
	 WHEN MATCHED  AND 
	          
	                    --CHECKSUM(*)
					   	HASHBYTES('MD5', CONCAT(Tsrc.DateMatchKey, Tsrc.KindOfSportKey, 
						                        Tsrc.BetResultKey, Tsrc.MatchName, Tsrc.RealResult, Tsrc.Koef)
					              )  
 					  !=
					   	HASHBYTES('MD5', CONCAT(Tdest.DateMatchKey, Tdest.KindOfSportKey,
						                        Tdest.BetResultKey, Tdest.MatchName, Tdest.RealResult, Tdest.Koef)
					              ) 
					
	  THEN 
	  UPDATE SET 
             	  DateMatchKey			= Tsrc.DateMatchKey,
				  KindOfSportKey		= Tsrc.KindOfSportKey,
				  BetResultKey			= Tsrc.BetResultKey,
				  MatchName				= Tsrc.MatchName,				  
				  RealResult			= Tsrc.RealResult,
				  Koef					= Tsrc.Koef				  
  
	   OPTION (/*RECOMPILE, */ QUERYTRACEON 8649, QUERYTRACEON 610)
	   ; 
END