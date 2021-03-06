USE [OlAP_Analysis]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetProfitPerKindOfSport]    Script Date: 12/24/2013 3:00:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_GetProfitPerKindOfSport]
 @BetValue int = 20
AS
BEGIN

DECLARE @MaxDate date;

select @MaxDate = max(d.FullDateAlternateKey)
from dbo.FactBet f
  join DimDate d on f.DateBetKey = d.DateKey;

with CTE_Week AS
(
select k.KindOfSportName,  
       -- from last month  	   
			CAST(sum(
		          case when BetResultKey = 3 then koef*@BetValue-@BetValue
					   when BetResultKey = 2 then -@BetValue
		          else 0
				  end) AS Numeric(10,2))
		AS SummaLastWeek,		
			CAST(sum(	      
					case when koef<=3 and BetResultKey = 3 then koef*@BetValue-@BetValue		       
			             when koef<=3 and BetResultKey = 2 then -@BetValue
						 when koef>3 and koef <=4 and BetResultKey = 3 then koef*(@BetValue/2)-(@BetValue/2)
						 when koef>3 and koef <=4 and BetResultKey = 2 then -(@BetValue/2)
						 when koef>4 and BetResultKey = 3 then koef*(@BetValue/4)-(@BetValue/4)
			             when koef>4 and BetResultKey = 2 then -(@BetValue/4)
					else 0 
					end) AS Numeric(10,2))
		 AS SummaDiffByKoefLastWeek,
      count(1) as KolWeek
from dbo.FactBet f
 join DimDate d on f.DateBetKey = d.DateKey
 join DimKindOfSport k on f.KindOfSportKey = k.KindOfSportKey
where DATEDIFF(DD,d.FullDateAlternateKey,@MaxDate) <= 7
group by k.KindOfSportName
),
CTE_Month AS
(
select k.KindOfSportName,  
       -- from last month  	   
			CAST(sum(
		          case when BetResultKey = 3 then koef*@BetValue-@BetValue
					   when BetResultKey = 2 then -@BetValue
		          else 0
				  end) AS Numeric(10,2))
		AS SummaLastMonth,		
			CAST(sum(	      
					case when koef<=3 and BetResultKey = 3 then koef*@BetValue-@BetValue		       
			             when koef<=3 and BetResultKey = 2 then -@BetValue
						 when koef>3 and koef <=4 and BetResultKey = 3 then koef*(@BetValue/2)-(@BetValue/2)
						 when koef>3 and koef <=4 and BetResultKey = 2 then -(@BetValue/2)
						 when koef>4 and BetResultKey = 3 then koef*(@BetValue/4)-(@BetValue/4)
			             when koef>4 and BetResultKey = 2 then -(@BetValue/4)
					else 0 
					end) AS Numeric(10,2))
		 AS SummaDiffByKoefLastMonth,
      count(1) as KolMonth
from dbo.FactBet f
 join DimDate d on f.DateBetKey = d.DateKey
 join DimKindOfSport k on f.KindOfSportKey = k.KindOfSportKey
where DATEDIFF(MM,d.FullDateAlternateKey,@MaxDate) <= 1
group by k.KindOfSportName
),
CTE_3Month AS
(
select k.KindOfSportName,  
       -- from last month  	   
			CAST(sum(
		          case when BetResultKey = 3 then koef*@BetValue-@BetValue
					   when BetResultKey = 2 then -@BetValue
		          else 0
				  end) AS Numeric(10,2))
		AS SummaLast3Month,		
			CAST(sum(	      
					case when koef<=3 and BetResultKey = 3 then koef*@BetValue-@BetValue		       
			             when koef<=3 and BetResultKey = 2 then -@BetValue
						 when koef>3 and koef <=4 and BetResultKey = 3 then koef*(@BetValue/2)-(@BetValue/2)
						 when koef>3 and koef <=4 and BetResultKey = 2 then -(@BetValue/2)
						 when koef>4 and BetResultKey = 3 then koef*(@BetValue/4)-(@BetValue/4)
			             when koef>4 and BetResultKey = 2 then -(@BetValue/4)
					else 0 
					end) AS Numeric(10,2))
		 AS SummaDiffByKoefLast3Month,
      count(1) as Kol3Month
from dbo.FactBet f
 join DimDate d on f.DateBetKey = d.DateKey
 join DimKindOfSport k on f.KindOfSportKey = k.KindOfSportKey
where DATEDIFF(MM,d.FullDateAlternateKey,@MaxDate) <= 3
group by k.KindOfSportName
),
CTE_6Month AS
(
select k.KindOfSportName,  
       -- from last month  	   
			CAST(sum(
		          case when BetResultKey = 3 then koef*@BetValue-@BetValue
					   when BetResultKey = 2 then -@BetValue
		          else 0
				  end) AS Numeric(10,2))
		AS SummaLast6Month,		
			CAST(sum(	      
					case when koef<=3 and BetResultKey = 3 then koef*@BetValue-@BetValue		       
			             when koef<=3 and BetResultKey = 2 then -@BetValue
						 when koef>3 and koef <=4 and BetResultKey = 3 then koef*(@BetValue/2)-(@BetValue/2)
						 when koef>3 and koef <=4 and BetResultKey = 2 then -(@BetValue/2)
						 when koef>4 and BetResultKey = 3 then koef*(@BetValue/4)-(@BetValue/4)
			             when koef>4 and BetResultKey = 2 then -(@BetValue/4)
					else 0 
					end) AS Numeric(10,2))
		 AS SummaDiffByKoefLast6Month,
      count(1) as Kol6Month
from dbo.FactBet f
 join DimDate d on f.DateBetKey = d.DateKey
 join DimKindOfSport k on f.KindOfSportKey = k.KindOfSportKey
where DATEDIFF(MM,d.FullDateAlternateKey,@MaxDate) <= 6
group by k.KindOfSportName
)  
,
CTE_Year AS
(
select k.KindOfSportName,  
       -- from last month  	   
			CAST(sum(
		          case when BetResultKey = 3 then koef*@BetValue-@BetValue
					   when BetResultKey = 2 then -@BetValue
		          else 0
				  end) AS Numeric(10,2))
		AS SummaLastYear,		
			CAST(sum(	      
					case when koef<=3 and BetResultKey = 3 then koef*@BetValue-@BetValue		       
			             when koef<=3 and BetResultKey = 2 then -@BetValue
						 when koef>3 and koef <=4 and BetResultKey = 3 then koef*(@BetValue/2)-(@BetValue/2)
						 when koef>3 and koef <=4 and BetResultKey = 2 then -(@BetValue/2)
						 when koef>4 and BetResultKey = 3 then koef*(@BetValue/4)-(@BetValue/4)
			             when koef>4 and BetResultKey = 2 then -(@BetValue/4)
					else 0 
					end) AS Numeric(10,2))
		 AS SummaDiffByKoefLastYear,
      count(1) as KolYear
from dbo.FactBet f
 join DimDate d on f.DateBetKey = d.DateKey
 join DimKindOfSport k on f.KindOfSportKey = k.KindOfSportKey
where DATEDIFF(YY,d.FullDateAlternateKey,@MaxDate) <= 1
group by k.KindOfSportName
)

select w.KindOfSportName, w.KolWeek,  w.SummaLastWeek, w.SummaDiffByKoefLastWeek,
                          m.KolMonth, m.SummaLastMonth, m.SummaDiffByKoefLastMonth,
						  m3.Kol3Month, m3.SummaLast3Month, m3.SummaDiffByKoefLast3Month,
						  m6.Kol6Month, m6.SummaLast6Month, m6.SummaDiffByKoefLast6Month,
						  y.KolYear, y.SummaLastYear, y.SummaDiffByKoefLastYear
from CTE_Week w 
  join CTE_Month m on w.KindOfSportName = m.KindOfSportName
  join CTE_3Month m3 on m.KindOfSportName = m3.KindOfSportName
  join CTE_6Month m6 on m3.KindOfSportName = m6.KindOfSportName
  join CTE_Year y on m6.KindOfSportName = y.KindOfSportName
order by 4 DESC

END

--select d.FullDateAlternateKey, DATEDIFF(DD,d.FullDateAlternateKey,getdate())
--from dbo.FactBet f
-- join DimDate d on f.DateBetKey = d.DateKey