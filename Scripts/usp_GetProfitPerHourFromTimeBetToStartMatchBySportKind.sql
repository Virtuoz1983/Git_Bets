USE [OlAP_Analysis]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetProfitPerHourFromTimeBetToStartMatchBySportKind]    Script Date: 12/24/2013 3:00:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_GetProfitPerHourFromTimeBetToStartMatchBySportKind] @BetValue int = 20
AS
BEGIN
select s.KindOfSportName,
       DATEDIFF(HH,CAST(CAST(d1.FullDateAlternateKey AS varchar) + ' ' + CAST(t1.FullTimeAlternateKey as varchar) AS datetime),
                   CAST(CAST(d2.FullDateAlternateKey AS varchar) + ' ' + CAST(t2.FullTimeAlternateKey as varchar) AS datetime)) AS DifHour, 
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
	      ) AS Numeric(9,2)) AS SummaDiffByKoef,
        CAST(sum(
          case when BetResultKey = 3 then koef*@BetValue-@BetValue
               when BetResultKey = 2 then -@BetValue
          else 0
          end
		  )/ count(1) AS numeric(9,2)) as ProfPerStakeOfSumma
from dbo.FactBet f
 join DimDate d1 on f.DateBetKey = d1.DateKey
 join DimDate d2 on f.DateMatchKey = d2.DateKey
 join DimTime t1 on f.TimeBetKey = t1.TimeKey
 join DimTime t2 on f.TimeMatchKey = t2.TimeKey
 join DimKindOfSport s on f.KindOfSportKey = s.KindOfSportKey
group by s.KindOfSportName, 
         DATEDIFF(HH,CAST(CAST(d1.FullDateAlternateKey AS varchar) + ' ' + CAST(t1.FullTimeAlternateKey as varchar) AS datetime),
                   CAST(CAST(d2.FullDateAlternateKey AS varchar) + ' ' + CAST(t2.FullTimeAlternateKey as varchar) AS datetime))
having count(1) >=5
order by 1,6 DESC
END