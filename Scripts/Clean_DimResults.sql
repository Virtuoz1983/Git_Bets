/*
select * from FactBet
where ResultKey = 6259
*/

update FactBet 
set ResultKey = 9443
where ResultKey in 
(
11552
)

delete from DimResult
where ResultKey in
(
11552
)

select *
from DimResult r
order by r.ResultName