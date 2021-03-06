USE [OlAP_Analysis]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetProfitByKindOfSportPerDay]    Script Date: 12/17/2013 10:46:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_GetProfitByKindOfSportPerDay] @BetValue int = 20, @DateKey int = NULL
-- By kinds of sports
AS
BEGIN

select k.KindOfSportName,  
       f.DateBetKey,
       sum(
          case when BetResultKey = 3 then koef*@BetValue-@BetValue
               when BetResultKey = 2 then -@BetValue
          else 0
          end
		  ) AS Summa,
	   sum(	      
	      case when koef<=3 and BetResultKey = 3 then koef*@BetValue-@BetValue		       
               when koef<=3 and BetResultKey = 2 then -@BetValue
			   when koef>3 and koef <=4 and BetResultKey = 3 then koef*(@BetValue/2)-(@BetValue/2)
               when koef>3 and koef <=4 and BetResultKey = 2 then -(@BetValue/2)
			   when koef>4 and BetResultKey = 3 then koef*(@BetValue/4)-(@BetValue/4)
               when koef>4 and BetResultKey = 2 then -(@BetValue/4)
          else 0
          end
	      ) AS SummaDiffByKoef
from dbo.FactBet f
 join DimKindOfSport k on f.KindOfSportKey = k.KindOfSportKey
where (f.DateBetKey = @DateKey OR @DateKey is null)
group by k.KindOfSportName, f.DateBetKey
order by 2

END
