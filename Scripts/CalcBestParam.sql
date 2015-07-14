declare @BetValue INT = 20
declare @ParamForBet FLOAT = -1
--declare @ParamForBet2 FLOAT = 0.1
declare @ParamForReverseBet FLOAT = 0


CREATE TABLE #tt
(
ParamBet float NULL,
ParamReverseBet float NULL,
ProfitBet float NULL,
ProfitRevers float NULL,
Kol INT NULL,
Paramkol FLOAT NULL
)

WHILE @ParamForBet < 1
BEGIN

SET @ParamForReverseBet = @ParamForBet*-1;

INSERT INTO #tt 
SELECT CONVERT(numeric(9,2), @ParamForBet),
	   CONVERT(numeric(9,2), @ParamForReverseBet),
	   CONVERT(numeric(9,2), SUM(B.RealProfit)) AS RealProfit,
	   CONVERT(numeric(9,2), SUM(B.RealReverseProfit)) AS RealReverseProfit,
	   SUM(B.Kol) AS Kol,
	   CASE WHEN  SUM(B.Kol) <> 0 THEN  SUM(B.RealProfit)/SUM(B.Kol) ELSE 0 END 
FROM
(

--declare @BetValue INT = 20
--declare @ParamForBet FLOAT = -0.07
--declare @ParamForReverseBet FLOAT = 0

SELECT A.DateMatch, KPI1, KPI2, KPI3, KPI4, KPI5, KPI6, KPI7, KPI8,
	   /*KPI1 + KPI2 +*/ KPI3 + KPI4 + KPI5 + KPI6 + KPI7 + KPI8 AS SumAllKPIs,
	   CASE WHEN /*KPI1 + KPI2 +*/ KPI3 + KPI4 + KPI5 + KPI6 + KPI7 + KPI8 >= @ParamForBet THEN 'Bet'
	   ELSE 'Not Bet' END AS BetOrNotbet,
	   RealResult,
	   CASE WHEN (/*KPI1 + KPI2*/KPI3 + KPI4 + KPI5 + KPI6 + KPI7 + KPI8 >= @ParamForBet) AND			     
			     RealResult = 'Win' AND
		         (Koef - (Koef*0.05)) <= 3  THEN  (Koef - (Koef*0.05))*@BetValue-@BetValue 
			WHEN (/*KPI1 + KPI2 + */KPI3 + KPI4 + KPI5 + KPI6 + KPI7 + KPI8 >= @ParamForBet) AND			     
			     RealResult = 'Win' AND
		         (Koef - (Koef*0.05)) > 3  THEN  (Koef - (Koef*0.05))*(@BetValue/2)-(@BetValue/2)          
			WHEN (/*KPI1 + KPI2 + */KPI3 + KPI4 + KPI5 + KPI6 + KPI7 + KPI8 >= @ParamForBet) AND			 		 	 RealResult = 'Lose' AND
	 		 	 (Koef - (Koef*0.05)) <= 3 THEN  -1*@BetValue 
			WHEN (/*KPI1 + KPI2 + */KPI3 + KPI4 + KPI5 + KPI6 + KPI7 + KPI8 >= @ParamForBet) AND			 		 	 RealResult = 'Lose' AND
	 		 	 (Koef - (Koef*0.05)) > 3 THEN  -1*(@BetValue/2)
			ELSE 0 END AS RealProfit,
	   CASE WHEN /*KPI1 + KPI2 + */KPI3 + KPI4 + KPI5 + KPI6 + KPI7 + KPI8 < @ParamForReverseBet AND RealResult = 'Win' THEN  -1*@BetValue 
			WHEN /*KPI1 + KPI2 + */KPI3 + KPI4 + KPI5 + KPI6 + KPI7 + KPI8 < @ParamForReverseBet AND RealResult = 'Lose' THEN ((Koef - (Koef*0.05))/((Koef - (Koef*0.05))-1))*@BetValue-@BetValue  
			ELSE 0 END AS RealReverseProfit,
	   CASE WHEN (/*KPI1 + KPI2 + */KPI3 + KPI4 + KPI5 + KPI6 + KPI7 + KPI8 >= @ParamForBet) THEN 1
			ELSE 0 END AS Kol
		, koef	
			
FROM
(
SELECT 
	   ProfitChamp/1000.0 AS KPI1,	    
	   (ProfitChamp100*2.0)/1000.0 AS KPI2,	    
	   ProfitTournament/1000.0 AS KPI3,	    
	   (ProfitTournament100)/1000.0 AS KPI4,	    
	   ProfitKoefInterval/1000.0 AS KPI5,	    
	   CASE WHEN RIGHT(ResultSeries,3) = 'LLL' THEN 0.1 
			WHEN RIGHT(ResultSeries,3) = 'WWW' THEN -0.05 ELSE 0 END AS KPI6,
		CASE WHEN RIGHT(KoefSeries,3) = 'LLL' THEN 0.1 
			WHEN RIGHT(KoefSeries,3) = 'WWW' THEN -0.05 ELSE 0 END AS KPI7,
	   CASE WHEN (Koef >= 1.9) AND (Koef < 2.1) THEN 0.05 ELSE 0 END AS KPI8
       ,fa.* 
FROM Stage.FactAnalize fa
) A
) B

SET @ParamForBet = @ParamForBet + 0.01

END

SELECT * FROM #tt

DROP TABLE #tt


/*
declare @BetValue INT = 20
declare @ParamForBet FLOAT = 0
declare @ParamForReverseBet FLOAT = 0

SELECT KPI1, KPI2, KPI3, KPI4, KPI5, KPI6, KPI7, KPI8,
	   KPI1 + KPI2 + KPI3 + KPI4 + KPI5 + KPI6 + KPI7 + KPI8 AS SumAllKPIs,
	   CASE WHEN KPI1 + KPI2 + KPI3 + KPI4 + KPI5 + KPI6 + KPI7 + KPI8 >= @ParamForBet THEN 'Bet'
	   ELSE 'Not Bet' END AS BetOrNotbet,
	   RealResult,
	   CASE WHEN KPI1 + KPI2 + KPI3 + KPI4 + KPI5 + KPI6 + KPI7 + KPI8 >= @ParamForBet AND RealResult = 'Win' THEN  Koef*@BetValue-@BetValue 
			WHEN KPI1 + KPI2 + KPI3 + KPI4 + KPI5 + KPI6 + KPI7 + KPI8 >= @ParamForBet AND RealResult = 'Lose' THEN  -1*@BetValue 
			ELSE 0 END AS RealProfit,
	   CASE WHEN KPI1 + KPI2 + KPI3 + KPI4 + KPI5 + KPI6 + KPI7 + KPI8 < @ParamForReverseBet AND RealResult = 'Win' THEN  -1*@BetValue 
			WHEN KPI1 + KPI2 + KPI3 + KPI4 + KPI5 + KPI6 + KPI7 + KPI8 < @ParamForReverseBet AND RealResult = 'Lose' THEN (Koef/(Koef-1))*@BetValue-@BetValue  
			ELSE 0 END AS RealReverseProfit
       
FROM
(
SELECT ProfitChamp/1000.0 AS KPI1,	    
	   (ProfitChamp100*2.0)/1000.0 AS KPI2,	    
	   ProfitTournament/1000.0 AS KPI3,	    
	   (ProfitTournament100*2.0)/1000.0 AS KPI4,	    
	   ProfitKoefInterval/1000.0 AS KPI5,	    
	   CASE WHEN RIGHT(ResultSeries,3) = 'LLL' THEN 0.1 
			WHEN RIGHT(ResultSeries,3) = 'WWW' THEN -0.05 ELSE 0 END AS KPI6,
		CASE WHEN RIGHT(KoefSeries,3) = 'LLL' THEN 0.1 
			WHEN RIGHT(KoefSeries,3) = 'WWW' THEN -0.05 ELSE 0 END AS KPI7,
	   CASE WHEN Koef >= 1.9 AND Koef < 2.1 THEN 0.05 ELSE 0 END AS KPI8,	   
       fa.* 
FROM Stage.FactAnalize fa
WHERE DateMatch = '22.12.2014'
) A

--
SELECT * FROM Stage.FactAnalize fa
--DELETE from Stage.FactAnalize 
WHERE DateMatch = '22.12.2014'

*/

