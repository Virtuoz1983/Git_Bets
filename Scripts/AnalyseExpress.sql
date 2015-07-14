DECLARE @vCountGruop int;
DECLARE @SumBet INT = 10;
DECLARE @DateBet int = 20141101;


SELECT @vCountGruop = CASE WHEN COUNT(ID)%2 = 0 THEN COUNT(ID) ELSE COUNT(ID)+1 end
 FROM dbo.FactBet a  
WHERE a.DateBetKey = @DateBet;

WITH Bets_CTE 
AS
(
SELECT @DateBet AS DateBet, a.ID, a.Koef, a.BetResultKey, NTILE(@vCountGruop/2) OVER (ORDER BY ID) AS Grupa
 FROM dbo.FactBet a  
WHERE a.DateBetKey = @DateBet
) 
SELECT a.DateBet, a.id, a.koef, a.BetResultKey, b.Koef, b.BetResultKey, a.grupa, 
       CASE WHEN a.BetResultKey = 3 AND b.BetResultKey = 3 THEN (a.koef*b.Koef*@SumBet) - @SumBet
            WHEN a.BetResultKey = 1 AND b.BetResultKey = 3 THEN b.Koef*@SumBet - @SumBet     
            WHEN a.BetResultKey = 3 AND b.BetResultKey = 1 THEN a.Koef*@SumBet - @SumBet               
			WHEN a.BetResultKey = 1 AND b.BetResultKey = 1 THEN 0			
	   ELSE -@SumBet
	   END	AS KoefForExpress	   
FROM Bets_CTE a 
  JOIN Bets_CTE b ON a.Grupa = b.Grupa AND a.ID+1 = b.ID



--SELECT * FROM dbo.DimBetResult

/*
1	Draw
2	Lose
3	Win
*/

