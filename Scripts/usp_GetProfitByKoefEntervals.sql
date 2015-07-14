USE [OlAP_Analysis]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetProfitByKoefEntervals]    Script Date: 12/17/2013 11:16:04 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetProfitByKoefEntervals] @BetValue int = 20
AS
BEGIN
select '1.75 - 1.85' as Grad,
       @BetValue as BetValue,
         sum(
          case when BetResultKey = 3 then koef*@BetValue-@BetValue
               when BetResultKey = 2 then -@BetValue
          else 0
          end
		  ) AS Summa		
from dbo.FactBet 
where koef >=1.75 and koef < 1.85
union all
select '1.85 - 1.95' as Grad,
       @BetValue as BetValue,
         sum(
          case when BetResultKey = 3 then koef*@BetValue-@BetValue
               when BetResultKey = 2 then -@BetValue
          else 0
          end
		  ) AS Summa		
from dbo.FactBet 
where koef >=1.85 and koef < 1.95
union all
select '1.95 - 2.05' as Grad,
       @BetValue as BetValue,
         sum(
          case when BetResultKey = 3 then koef*@BetValue-@BetValue
               when BetResultKey = 2 then -@BetValue
          else 0
          end
		  ) AS Summa		
from dbo.FactBet 
where koef >=1.95 and koef < 2.05
union all
select '2.05 - 2.15' as Grad,
       @BetValue as BetValue,
         sum(
          case when BetResultKey = 3 then koef*@BetValue-@BetValue
               when BetResultKey = 2 then -@BetValue
          else 0
          end
		  ) AS Summa		
from dbo.FactBet 
where koef >=2.05 and koef < 2.15
union all
select '2.15 - 2.25' as Grad,
       @BetValue as BetValue,
         sum(
          case when BetResultKey = 3 then koef*@BetValue-@BetValue
               when BetResultKey = 2 then -@BetValue
          else 0
          end
		  ) AS Summa		
from dbo.FactBet 
where koef >=2.15 and koef < 2.25
union all
select '2.25 - 2.35' as Grad,
       @BetValue as BetValue,
         sum(
          case when BetResultKey = 3 then koef*@BetValue-@BetValue
               when BetResultKey = 2 then -@BetValue
          else 0
          end
		  ) AS Summa		
from dbo.FactBet 
where koef >=2.25 and koef < 2.35
union all
select '2.35 - 2.45' as Grad,
       @BetValue as BetValue,
         sum(
          case when BetResultKey = 3 then koef*@BetValue-@BetValue
               when BetResultKey = 2 then -@BetValue
          else 0
          end
		  ) AS Summa		
from dbo.FactBet 
where koef >=2.35 and koef < 2.45
union all
select '2.45 - 2.55' as Grad,
       @BetValue as BetValue,
         sum(
          case when BetResultKey = 3 then koef*@BetValue-@BetValue
               when BetResultKey = 2 then -@BetValue
          else 0
          end
		  ) AS Summa		
from dbo.FactBet 
where koef >=2.45 and koef < 2.55
union all
select '2.55 - 2.65' as Grad,
       @BetValue as BetValue,
         sum(
          case when BetResultKey = 3 then koef*@BetValue-@BetValue
               when BetResultKey = 2 then -@BetValue
          else 0
          end
		  ) AS Summa		
from dbo.FactBet 
where koef >=2.55 and koef < 2.65
union all
select '2.65 - 2.75' as Grad,
       @BetValue as BetValue,
         sum(
          case when BetResultKey = 3 then koef*@BetValue-@BetValue
               when BetResultKey = 2 then -@BetValue
          else 0
          end
		  ) AS Summa		
from dbo.FactBet 
where koef >=2.65 and koef < 2.75
union all
select '2.75 - 2.85' as Grad,
       @BetValue as BetValue,
         sum(
          case when BetResultKey = 3 then koef*@BetValue-@BetValue
               when BetResultKey = 2 then -@BetValue
          else 0
          end
		  ) AS Summa		
from dbo.FactBet 
where koef >=2.75 and koef < 2.85
union all
select '2.85 - 2.95' as Grad,
       @BetValue as BetValue,
         sum(
          case when BetResultKey = 3 then koef*@BetValue-@BetValue
               when BetResultKey = 2 then -@BetValue
          else 0
          end
		  ) AS Summa		
from dbo.FactBet 
where koef >=2.85 and koef < 2.95
union all
select '2.95 - 3.00' as Grad,
       @BetValue as BetValue,
         sum(
          case when BetResultKey = 3 then koef*@BetValue-@BetValue
               when BetResultKey = 2 then -@BetValue
          else 0
          end
		  ) AS Summa		
from dbo.FactBet 
where koef >=2.95 and koef < 3.00
union all
select '3.00 - 3.25' as Grad,
       (@BetValue/2) as BetValue,
         sum(
          case when BetResultKey = 3 then koef*(@BetValue/2)-(@BetValue/2)
               when BetResultKey = 2 then -(@BetValue/2)
          else 0
          end
		  ) AS Summa		
from dbo.FactBet 
where koef >=3.00 and koef < 3.25
union all
select '3.25 - 3.50' as Grad,
       (@BetValue/2) as BetValue,
         sum(
          case when BetResultKey = 3 then koef*(@BetValue/2)-(@BetValue/2)
               when BetResultKey = 2 then -(@BetValue/2)
          else 0
          end
		  ) AS Summa		
from dbo.FactBet 
where koef >=3.25 and koef < 3.5
union all
select '3.50 - 3.75' as Grad,
       (@BetValue/2) as BetValue,
         sum(
          case when BetResultKey = 3 then koef*(@BetValue/2)-(@BetValue/2)
               when BetResultKey = 2 then -(@BetValue/2)
          else 0
          end
		  ) AS Summa		
from dbo.FactBet 
where koef >=3.5 and koef < 3.75
union all
select '3.75 - 4.00' as Grad,
       (@BetValue/2) as BetValue,
         sum(
          case when BetResultKey = 3 then koef*(@BetValue/2)-(@BetValue/2)
               when BetResultKey = 2 then -(@BetValue/2)
          else 0
          end
		  ) AS Summa		
from dbo.FactBet 
where koef >=3.75 and koef < 4.00
union all
select '4.00 - 5.00' as Grad,
       (@BetValue/4) as BetValue,
         sum(
          case when BetResultKey = 3 then koef*(@BetValue/4)-(@BetValue/4)
               when BetResultKey = 2 then -(@BetValue/4)
          else 0
          end
		  ) AS Summa		
from dbo.FactBet 
where koef >=4.0 and koef < 5.0
union all
select '5.00 and more' as Grad,
       (@BetValue/4) as BetValue,
         sum(
          case when BetResultKey = 3 then koef*(@BetValue/4)-(@BetValue/4)
               when BetResultKey = 2 then -(@BetValue/4)
          else 0
          end
		  ) AS Summa		
from dbo.FactBet 
where koef >=5.0
END
GO


