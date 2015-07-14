-- Initial parameters
declare @BetValue INT = 20
declare @ParamForBet numeric(9,2) = -1

--declare @ParamInterval numeric(9,2) = 0.01
declare @ParamInterval numeric(9,2) = 0.02
--declare @ParamInterval numeric(9,2) = 0.04
--declare @ParamInterval numeric(9,2) = 0.1
--declare @ParamInterval numeric(9,2) = 0.2

--declare @ParamForReverseBet FLOAT = 0

--SELECT * FROM dbo.DimKindOfSport

CREATE TABLE #tt
(
ParamBet float NULL,
--ParamReverseBet float NULL,
ProfitBet float NULL,
Kol INT NULL,
Paramkol FLOAT NULL,
IntervalMin FLOAT NULL,
IntervalMax FLOAT NULL
)

WHILE @ParamForBet < 1
BEGIN

--SET @ParamForReverseBet = @ParamForBet*-1;

INSERT INTO #tt 
SELECT CONVERT(numeric(9,2), @ParamForBet),
	   --CONVERT(numeric(9,2), @ParamForReverseBet),
	   CONVERT(numeric(9,2), SUM(B.RealProfit)) AS RealProfit,	   
	   SUM(B.Kol) AS Kol,
	   CASE WHEN SUM(B.Kol) <> 0 THEN SUM(B.RealProfit)/SUM(B.Kol) ELSE 0 END,
	   CONVERT(numeric(9,2), @ParamForBet),
	   CONVERT(numeric(9,2), @ParamForBet+@ParamInterval)
FROM
(

--declare @BetValue INT = 20
--declare @ParamForBet FLOAT = 0.6
--declare @ParamInterval FLOAT = 0.64
--declare @ParamForReverseBet FLOAT = 0

SELECT BetResultKey,
	   --KPI3, KPI4, KPI5, KPI8,
	   KPI3 + KPI4 + KPI5 + KPI8 AS SumAllKPIs,	   
	   CASE WHEN (KPI3 + KPI4 + KPI5 + KPI8 >= @ParamForBet) AND			     
				 (KPI3 + KPI4 + KPI5 + KPI8 < (@ParamForBet+@ParamInterval)) AND 				  		 
			     BetResultKey = 3 AND
		         (Koef) <= 3  THEN  (Koef)*@BetValue-@BetValue 
			WHEN (KPI3 + KPI4 + KPI5 + KPI8 >= @ParamForBet) AND			     
				 (KPI3 + KPI4 + KPI5 + KPI8 < (@ParamForBet+@ParamInterval)) AND			     	
			     BetResultKey = 3 AND
		         (Koef) > 3  THEN  (Koef)*(@BetValue/2)-(@BetValue/2)          
			WHEN (KPI3 + KPI4 + KPI5 + KPI8 >= @ParamForBet) AND						 (KPI3 + KPI4 + KPI5 + KPI8 < (@ParamForBet+@ParamInterval)) AND			 		 	 BetResultKey = 2 AND
	 		 	 (Koef) <= 3 THEN  -1*@BetValue 
			WHEN (KPI3 + KPI4 + KPI5 + KPI8 >= @ParamForBet) AND					     (KPI3 + KPI4 + KPI5 + KPI8 < (@ParamForBet+@ParamInterval)) AND				 		 	 BetResultKey = 2 AND
	 		 	 (Koef) > 3 THEN  -1*(@BetValue/2)
			ELSE 0 END AS RealProfit,	   
	   CASE WHEN (KPI3 + KPI4 + KPI5 + KPI8 >= @ParamForBet) AND
				 (KPI3 + KPI4 + KPI5 + KPI8 < (@ParamForBet+@ParamInterval))   
	   	    THEN 1
			ELSE 0 END AS Kol
		, koef	
			
FROM dbo.FactBet A
WHERE A.DateBetKey >= 20140601
	  --AND A.DateBetKey <= 20140931
     -- AND A.KindOfSportKey = 4  -- Football  
     -- AND A.KindOfSportKey = 5  -- Hockey
	 --	AND A.KindOfSportKey = 2  -- Basketball
	 -- AND A.KindOfSportKey = 1003  -- Handball
	 -- AND A.KindOfSportKey = 1006  -- Tennis      
	 -- AND A.KindOfSportKey = 3028  -- Baseball
	 -- AND A.KindOfSportKey = 1002  -- Voleyball
	  AND A.KindOfSportKey IN (1005,1015,2025)  -- Rugby
) B

SET @ParamForBet = @ParamForBet + @ParamInterval

END

SELECT ProfitBet,IntervalMin 
	  ,IntervalMax, Kol, CASE WHEN kol <> 0 THEN CAST(ProfitBet/Kol AS NUMERIC(9,2)) ELSE 0 end
FROM #tt
--WHERE Kol > 50

DROP TABLE #tt

/*
SELECT KPI3 + KPI4 + KPI5 + KPI8, A.*, c.ChampName
 FROM dbo.FactBet A
 JOIN DimChamp c ON A.ChampKey = c.ChampKey
WHERE A.DateBetKey >= 20140601
      AND A.KindOfSportKey = 4  -- Football
      AND KPI3 + KPI4 + KPI5 + KPI8 >= 0.6

SELECT * FROM dbo.DimKindOfSport
*/

/*SELECT *
FROM dbo.FactBet A
WHERE A.DateBetKey >= 20140601
AND A.KindOfSportKey = 4 
*/