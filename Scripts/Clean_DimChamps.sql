
update FactBet 
set ChampKey = 27393
where ChampKey in 
(
14010,
14961
)

delete from DimChamp
where ChampKey IN
(
14010,
14961
)

select ChampKey, ChampName
from DimChamp
WHERE  ChampName LIKE N'%Гран-при%'
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