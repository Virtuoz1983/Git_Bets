USE [OlAP_Analysis]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetProfitPerKoef]    Script Date: 12/24/2013 3:01:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_GetProfitPerKoef] @BetValue int = 20
AS
BEGIN
select koef,
       @BetValue as BetValue,
         CAST(sum(
          case when BetResultKey = 3 then koef*@BetValue-@BetValue
               when BetResultKey = 2 then -@BetValue
          else 0
          end
		  ) AS Numeric(5,2)) AS Summa,
		  COUNT(1) as Kol
from dbo.FactBet 
group by koef
order by 3 DESC
END