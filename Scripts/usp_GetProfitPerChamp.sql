USE [OlAP_Analysis]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetProfitPerChamp]    Script Date: 12/24/2013 2:59:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_GetProfitPerChamp] @BetValue int = 20, @likeStr nvarchar(50) = NULL
AS
BEGIN

DECLARE @MaxDate date;

select @MaxDate = max(d.FullDateAlternateKey)
from dbo.FactBet f
  join DimDate d on f.DateBetKey = d.DateKey;


WITH CTE_Month AS 
( 
select s.KindOfSportName, k.ChampName,  
       CAST(sum(
          case when BetResultKey = 3 then koef*@BetValue-@BetValue
               when BetResultKey = 2 then -@BetValue
          else 0
          end
		  ) AS Numeric(9,2)) AS Summa_Month,
	   CAST(sum(	      
	      case when koef<=3 and BetResultKey = 3 then koef*@BetValue-@BetValue		       
               when koef<=3 and BetResultKey = 2 then -@BetValue
			   when koef>3 and koef <=4 and BetResultKey = 3 then koef*(@BetValue/2)-(@BetValue/2)
               when koef>3 and koef <=4 and BetResultKey = 2 then -(@BetValue/2)
			   when koef>4 and BetResultKey = 3 then koef*(@BetValue/4)-(@BetValue/4)
               when koef>4 and BetResultKey = 2 then -(@BetValue/4)
          else 0
          end
	      ) AS Numeric(9,2)) AS SummaDiffByKoef_Month,
       COUNT(1) as Kol_Month,
	   CAST(sum(
          case when BetResultKey = 3 then koef*@BetValue-@BetValue
               when BetResultKey = 2 then -@BetValue
          else 0
          end
		  )/COUNT(1) AS Numeric(9,2)) AS ProcSumma_Month,
       CAST(sum(	      
	      case when koef<=3 and BetResultKey = 3 then koef*@BetValue-@BetValue		       
               when koef<=3 and BetResultKey = 2 then -@BetValue
			   when koef>3 and koef <=4 and BetResultKey = 3 then koef*(@BetValue/2)-(@BetValue/2)
               when koef>3 and koef <=4 and BetResultKey = 2 then -(@BetValue/2)
			   when koef>4 and BetResultKey = 3 then koef*(@BetValue/4)-(@BetValue/4)
               when koef>4 and BetResultKey = 2 then -(@BetValue/4)
          else 0
          end
	      )/COUNT(1) AS Numeric(9,2)) AS ProcSummaDiffByKoef_Month
from dbo.FactBet f
 join DimDate d on f.DateBetKey = d.DateKey
 join DimChamp k on f.ChampKey = k.ChampKey
 join DimKindOfSport s on f.KindOfSportKey = s.KindOfSportKey
where ((k.ChampName like N'%' + @likeStr +'%') or (@likeStr is null))
   and DATEDIFF(MM,d.FullDateAlternateKey,@MaxDate) <= 1
group by s.KindOfSportName, k.ChampName
),
CTE_All AS
(
select s.KindOfSportName, k.ChampName,  
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
       COUNT(1) as Kol,
	   CAST(sum(
          case when BetResultKey = 3 then koef*@BetValue-@BetValue
               when BetResultKey = 2 then -@BetValue
          else 0
          end
		  )/COUNT(1) AS Numeric(9,2)) AS ProcSumma,
       CAST(sum(	      
	      case when koef<=3 and BetResultKey = 3 then koef*@BetValue-@BetValue		       
               when koef<=3 and BetResultKey = 2 then -@BetValue
			   when koef>3 and koef <=4 and BetResultKey = 3 then koef*(@BetValue/2)-(@BetValue/2)
               when koef>3 and koef <=4 and BetResultKey = 2 then -(@BetValue/2)
			   when koef>4 and BetResultKey = 3 then koef*(@BetValue/4)-(@BetValue/4)
               when koef>4 and BetResultKey = 2 then -(@BetValue/4)
          else 0
          end
	      )/COUNT(1) AS Numeric(9,2)) AS ProcSummaDiffByKoef
from dbo.FactBet f
 join DimDate d on f.DateBetKey = d.DateKey
 join DimChamp k on f.ChampKey = k.ChampKey
 join DimKindOfSport s on f.KindOfSportKey = s.KindOfSportKey
where ((k.ChampName like N'%' + @likeStr +'%') or (@likeStr is null))   
group by s.KindOfSportName, k.ChampName
)

select m.KindOfSportName, m.ChampName, m.Summa_Month as S_Month, m.SummaDiffByKoef_Month as SDif_Month, m.Kol_Month,
                                       m.ProcSumma_Month as Proc_Month, m.ProcSummaDiffByKoef_Month as ProcDif_Month,
                                       a.Summa, a.SummaDiffByKoef as SummaDif, a.Kol, a.ProcSumma, a.ProcSummaDiffByKoef as ProcDiff 
from CTE_Month m
  join CTE_All a on m.ChampName = a.ChampName 
order by 3 DESC

END