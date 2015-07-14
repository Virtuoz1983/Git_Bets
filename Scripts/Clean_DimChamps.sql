
update FactBet 
set ChampKey = 19261
where ChampKey in 
(
8807
)

delete from DimChamp
where ChampKey IN
(
8807
)

select ChampKey, ChampName
from DimChamp
--WHERE  ChampName LIKE N'%евротур%'
order by ChampName


/*
update DimChamp
SET ChampName = 'Кувейт. Кубок наследного принца'
WHERE ChampKey = 1232
GO
select ChampKey, ChampName from DimChamp order by ChampName
*/
/*
select * 
from FactBet where ChampKey = 13025
*/