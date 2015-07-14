SELECT * FROM Stage.FactBet
--exec dbo.usp_FactBet_Merge
exec dbo.usp_GetProfit 20
exec dbo.usp_GetProfitPerDay 20
exec dbo.usp_GetProfitPerKindOfSport 20
exec dbo.usp_GetProfitPerKindOfSportPerDay 20

Declare @Sport nvarchar(50) = NULL -- 'футб'
Declare @Champ nvarchar(50) = NULL -- 'Германия. 2-я бундеслига '
--exec dbo.usp_GetProfitPerChamp 25, @Sport, @Champ
exec dbo.usp_GetProfitPerChampDetailed 20, @Sport, @Champ-- 'Англия / Пр' -- Серия А / -- 'хия / Экстра'

exec dbo.usp_WorkTodayByHour 20
exec dbo.usp_WorkEveryDayByHour 20

exec dbo.usp_getprofitperdayofweek 20
exec dbo.usp_GetProfitPerHour
exec dbo.usp_GetProfitPerKoefEntervals
exec dbo.usp_GetProfitPerKoef
exec dbo.usp_GetProfitPerResults
exec dbo.usp_GetProfitPerKindOfSportAndDayOfWeek
exec dbo.usp_GetProfitPerHourFromTimeBetToStartMatch
exec dbo.usp_GetProfitPerHourFromTimeBetToStartMatchBySportKind

select *
from DimDate

select r.ResultName, br.BetResultName, count(1)
from dbo.FactBet f
     join DimChamp c on f.ChampKey = c.ChampKey 
	 join DimResult r on f.ResultKey = r.ResultKey 
	 join DimBetResult br on f.BetResultKey = br.BetResultKey 
where c.ChampName like N'%NBA%%'
and f.DateBetKey between 20140301 and 20140401
group by r.ResultName, br.BetResultName

select * from dbo.FactBet where BetResultKey not in (1,2,3)
select * from DimChamp c where c.ChampName like N'%PBA%%'

select * from DimResult where ResultKey in (4,1004)

exec Stage.usp_StageBetFact_Prepare
exec dbo.usp_FactBet_Merge

select * from DimBetResult
--DELETE FROM Stage.FactBet
--where DateBetKey is null;

DECLARE @BetValue int = 20;

select count(1) as kol, k.ChampName, s.KindOfSportName
from dbo.FactBet f 
 join DimChamp k on f.ChampKey = k.ChampKey
 join DimKindOfSport s on f.KindOfSportKey = s.KindOfSportKey
where k.ChampName like N'%Англ%'
group by k.ChampName, s.KindOfSportName

	select *	
	from FactBet
	where DateBetKey = 20150401 	

CREATE TABLE #aaa
( hn INT, 
  n NVARCHAR(12),
  summ NUMERIC(9,2),
  sumdm NUMERIC(9,2),
  pm NUMERIC(9,2), 
  suma NUMERIC(9,2),
  sumda NUMERIC(9,2),
  pa NUMERIC(9,2)
)
INSERT #aaa EXECUTE dbo.usp_WorkEveryDayByHour 25

SELECT * FROM #aaa
--ORDER BY sumdm desc
ORDER BY sumda desc

DROP TABLE #aaa

declare @BetValue int = 20;

select t.HourNumber,
       d.DayNameOfWeek,
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
	      case when koef<=3 and BetResultKey = 3 then koef*@BetValue-@BetValue		       
               when koef<=3 and BetResultKey = 2 then -@BetValue
			   when koef>3 and koef <=4 and BetResultKey = 3 then koef*(@BetValue/2)-(@BetValue/2)
               when koef>3 and koef <=4 and BetResultKey = 2 then -(@BetValue/2)
			   when koef>4 and BetResultKey = 3 then koef*(@BetValue/4)-(@BetValue/4)
               when koef>4 and BetResultKey = 2 then -(@BetValue/4)
          else 0
          end
		  )/ count(1) AS numeric(9,2)) as ProfPerStakeOfSumma
from dbo.FactBet f
 join DimTime t on f.TimeBetKey = t.TimeKey
 join DimDate d on f.DateBetKey = d.DateKey
--where DateBetKey in (20140315, 20140316)
--where DayNameOfWeek in ('Saturday', 'Sunday')
where DateBetKey = 20141231
group by t.HourNumber, d.DayNameOfWeek
--having  count(1) > 5
order by 2,6 desc



CREATE NONCLUSTERED INDEX NIX_FactBet_DateKey ON dbo.FactBet(DateBetKey)
