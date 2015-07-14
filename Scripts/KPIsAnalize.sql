Declare @BetValue INT = 20;

--SELECT * FROM DBO.DimKindOfSport

WITH
CalcKPI8 AS
(
SELECT f.ID, 
	   CASE WHEN f.KindOfSportKey = 4 AND ((f.Koef >= 2.0 AND f.Koef < 2.1) OR (f.Koef >= 2.2 AND f.koef < 2.4)) THEN 0.05		-- football
		    WHEN f.KindOfSportKey = 5 AND ((f.Koef >= 1.8 AND f.Koef < 1.9) OR (f.Koef >= 1.9 AND f.koef < 2.0)) THEN 0.05		-- hockey
			WHEN f.KindOfSportKey = 2 AND ((f.Koef >= 1.9 AND f.Koef < 2.0) OR (f.Koef >= 2.0 AND f.koef < 2.1)) THEN 0.05		-- basket
			WHEN f.KindOfSportKey = 1003 AND ((f.Koef >= 1.7 AND f.Koef < 1.8) OR (f.Koef >= 1.9 AND f.koef < 2.0)) THEN 0.05   -- handball
			WHEN f.KindOfSportKey = 1006 AND (f.Koef >= 2.0 AND f.Koef < 2.1) THEN 0.05   -- tennis	
		    WHEN f.KindOfSportKey = 1002 AND ((f.Koef >= 2.4 AND f.Koef < 2.6) OR (f.Koef >= 4.0 AND f.koef < 5.0)) THEN 0.05	-- voleyball
			WHEN f.Koef >= 1.9 AND f.Koef < 2.1 THEN 0.05 ELSE 0 end AS KPI8       
FROM dbo.FactBet f  
WHERE f.DateBetKey >= 20140601
), 
CalcKPI3 AS
(
SELECT f1.ID,  ISNULL(AA1.KPI3,0) AS KPI3
FROM dbo.FactBet f1
LEFT JOIN 
(
SELECT f.ID, 	
       SUM(pc.ProfPerChamp)/1000.0 AS KPI3  
FROM dbo.FactBet f
  INNER JOIN 
  (
	select   
	 fb.ChampKey,
	 fb.DateBetKey,   
	 fb.ResultKey,
     SUM( 
     case when koef<=3 and BetResultKey = 3 then koef*@BetValue-@BetValue		       
               when koef<=3 and BetResultKey = 2 then -@BetValue
			   when koef>3  and BetResultKey = 3 then koef*(@BetValue/2)-(@BetValue/2)
               when koef>3  and BetResultKey = 2 then -(@BetValue/2)	
     else 0 END) AS ProfPerChamp  
    FROM dbo.FactBet fb       
    GROUP BY fb.ChampKey, fb.DateBetKey, fb.ResultKey
   ) pc ON pc.ChampKey = f.ChampKey AND pc.ResultKey = f.ResultKey
WHERE pc.DateBetKey < f.DateBetKey AND f.DateBetKey >= 20140601
group by f.ID
) AA1 ON F1.ID = AA1.ID
WHERE f1.DateBetKey >= 20140601
), 
CalcKPI4 AS
(
SELECT f2.ID,  ISNULL(AA1.KPI4,0) AS KPI4
FROM dbo.FactBet f2
LEFT JOIN 
(
SELECT f.ID, 	
       SUM(pc.ProfPerChamp)/1000.0 AS KPI4  
FROM dbo.FactBet f
  INNER JOIN 
  (
	select   
	 fb.ChampKey,
	 fb.DateBetKey,   
	 fb.ResultKey,
     SUM( 
     case when koef<=3 and BetResultKey = 3 then koef*@BetValue-@BetValue		       
               when koef<=3 and BetResultKey = 2 then -@BetValue
			   when koef>3  and BetResultKey = 3 then koef*(@BetValue/2)-(@BetValue/2)
               when koef>3  and BetResultKey = 2 then -(@BetValue/2)	
     else 0 END) AS ProfPerChamp  
    FROM dbo.FactBet fb 
      INNER JOIN dbo.DimDate d ON fb.DateBetKey = d.DateKey  
	WHERE DATEDIFF(DD,d.FullDateAlternateKey,getdate()) <= 100   	      
    GROUP BY fb.ChampKey, fb.DateBetKey, fb.ResultKey
   ) pc ON pc.ChampKey = f.ChampKey AND pc.ResultKey = f.ResultKey
WHERE pc.DateBetKey < f.DateBetKey AND f.DateBetKey >= 20140601
group by f.ID
) AA1 ON F2.ID = AA1.ID
WHERE f2.DateBetKey >= 20140601
), 
CalcKPI5 AS
(
SELECT f3.ID,  ISNULL(AA1.KPI5,0) AS KPI5
FROM dbo.FactBet f3
LEFT JOIN 
(
SELECT f.ID, 	
       SUM(pc.ProfPerKI)/1000.0 AS KPI5
FROM dbo.FactBet f
  INNER JOIN 
  (
	select   
	 fb.ChampKey,
	 fb.DateBetKey,   
	 fb.ResultKey,
	 fb.KIKey,
     SUM( 
     case when koef<=3 and BetResultKey = 3 then koef*@BetValue-@BetValue		       
               when koef<=3 and BetResultKey = 2 then -@BetValue
			   when koef>3  and BetResultKey = 3 then koef*(@BetValue/2)-(@BetValue/2)
               when koef>3  and BetResultKey = 2 then -(@BetValue/2)	
     else 0 END) AS ProfPerKI
    FROM dbo.FactBet fb                                
    GROUP BY fb.ChampKey, fb.DateBetKey, fb.ResultKey, fb.KIKey
   ) pc ON pc.ChampKey = f.ChampKey AND pc.ResultKey = f.ResultKey AND pc.KIKey = f.KIkey
WHERE pc.DateBetKey < f.DateBetKey AND f.DateBetKey >= 20140601
group by f.ID
)
AA1 ON F3.ID = AA1.ID
WHERE f3.DateBetKey >= 20140601
)
UPDATE f
 SET 
    f.KPI3 = cKPI3.KPI3,
    f.KPI4 = cKPI4.KPI4,
	f.KPI5 = cKPI5.KPI5,
	f.KPI8 = cKPI8.KPI8    
--SELECT f.ID, c.ChampName, f.koef, cKPI3.KPI3, cKPI4.KPI4, cKPI5.KPI5, cKPI8.KPI8, f.DateBetKey,
--cKPI3.KPI3 + cKPI4.KPI4 + cKPI5.KPI5 + cKPI8.KPI8, r.ResultName
FROM dbo.FactBet f
 JOIN dbo.DimChamp c ON f.ChampKey = c.ChampKey 
 JOIN dbo.DimResult r ON f.ResultKey = r.ResultKey  
 JOIN CalcKPI3 cKPI3 ON f.ID = cKPI3.ID
 JOIN CalcKPI4 cKPI4 ON f.ID = cKPI4.ID
 JOIN CalcKPI5 cKPI5 ON f.ID = cKPI5.ID 
 JOIN CalcKPI8 cKPI8 ON f.ID = cKPI8.ID 
WHERE f.KPI3 IS NULL AND f.KPI4 IS NULL
--WHERE champName LIKE N'%ибертад%'
--ORDER BY f.DateBetKey desc

-- select * FROM FactBet WHERE ID = 23396
 
 --SELECT * FROM dbo.DimChamp WHERE ChampKey = 15149
 --SELECT * FROM dbo.DimKindOfSport WHERE KindOfSportKey = 4
 
 --SELECT * from dbo.FactBet WHERE DateBetKey BETWEEN 20150207 AND 20150207
 

/*
Declare @BetValue INT = 20;

SELECT f.ID, f.DateBetKey, f.KindOfSportKey, f.MatchName, f.ChampKey,
       c.ChampName,          
	   SUM( 
       case when koef<=3 and BetResultKey = 3 then koef*@BetValue-@BetValue		       
               when koef<=3 and BetResultKey = 2 then -@BetValue
			   when koef>3  and BetResultKey = 3 then koef*(@BetValue/2)-(@BetValue/2)
               when koef>3  and BetResultKey = 2 then -(@BetValue/2)	
      else 0 END) OVER (PARTITION BY c.ChampKey ORDER BY DateBetKey
						ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)						 
       AS SumaPred,       						
       f.Koef         
FROM dbo.FactBet f  
  INNER JOIN dbo.DimChamp c ON f.ChampKey = c.ChampKey
--WHERE f.DateBetKey BETWEEN 20141225 AND 20141225;
ORDER BY DateBetKey
*/

/*

SELECT * 
FROM Stage.FactAnalize 
WHERE RealResult = 'Lose'

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
	   CASE WHEN (Koef >= 1.9) AND (Koef < 2.1) THEN 0.05 ELSE 0 END AS KPI8,
	     	     
	   ProfitChamp/1000.0 +
	   (ProfitChamp100*2.0)/1000.0 +  
	   ProfitTournament/1000.0 +
	   (ProfitTournament100)/1000.0 +
	   ProfitKoefInterval/1000.0  AS SummKPIs,	   
	   ProfitTournament/1000.0 +
	   (ProfitTournament100)/1000.0 +
	   ProfitKoefInterval/1000.0  AS SumNotAllKPIs
	   ,fa.realresult    		 
       --,fa.* 
FROM Stage.FactAnalize fa
WHERE RealResult = 'Win'


*/



--SELECT * 
--FROM dbo.FactBet f
--WHERE f.DateBetKey >= 20140601