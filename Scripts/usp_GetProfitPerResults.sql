USE [OlAP_Analysis]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetProfitPerResults]    Script Date: 12/24/2013 3:01:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_GetProfitPerResults] @BetValue int = 20
AS
BEGIN
select s.KindOfSportName, r.ResultName,  
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
       count(1) as Kol
from dbo.FactBet f
 join DimResult r on f.ResultKey = r.ResultKey
 join DimKindOfSport s on f.KindOfSportKey = s.KindOfSportKey
group by s.KindOfSportName, r.ResultName
order by 3 DESC
END


