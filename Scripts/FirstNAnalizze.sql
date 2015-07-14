declare @BetValue int = 20;

select d.CalendarYear,
       d.MonthName,
       count(1) as Kol,
       CAST(sum(
          case when BetResultKey = 3 then koef*@BetValue-@BetValue
               when BetResultKey = 2 then -@BetValue
          else 0
          end
		  ) AS Numeric(9,2)) AS Summa,
	   CAST(sum(	      
	      case when koef<=3 and BetResultKey = 3 then koef*@BetValue-@BetValue		       
               when koef<=3 and BetResultKey = 2 then -@BetValue
			   when koef>3 and koef <=4 and BetResultKey = 3 then koef*(@BetValue/2)-(@BetValue/2)
               when koef>3 and koef <=4 and BetResultKey = 2 then -(@BetValue/2)
			   when koef>4 and BetResultKey = 3 then koef*(@BetValue/4)-(@BetValue/4)
               when koef>4 and BetResultKey = 2 then -(@BetValue/4)
          else 0
          end
	      ) AS Numeric(9,2)) AS SummaDiffByKoef        
FROM dbo.FactBet f
 JOIN dbo.DimDate d ON f.DateBetKey = d.DateKey
where f.ID IN 
(
SELECT A.ID
FROM
(
SELECT ID,
	   DateBetKey,
	   champKey,  
	   ROW_ID = ROW_NUMBER() OVER (PARTITION BY DateBetKey ORDER BY DateBetKey DESC)
FROM dbo.FactBet f
) A 
WHERE A.ROW_ID <= 4
--ORDER BY A.ID desc, A.ROW_ID
) 
GROUP BY d.CalendarYear, d.MonthName
ORDER BY 1,2 DESC