

SELECT * FROM IPLPlayers

--- Q1 Find the total spending on players for each team

SELECT 
	 team,
	 sum(price_in_cr) AS total_spending
FROM IPLPlayers
GROUP BY 1 
ORDER BY 2 desc

---- Q2 Find the top 3 highest-paid 'all-rounders' across all teams

SELECT 
    player,
	role_players,
	price_in_cr
FROM IPLPlayers
WHERE role_players = 'All-rounder'
ORDER BY 3 DESC
LIMIT 3


---Q3 Find the highest priced player in each team 


WITH CTE AS(
SELECT 
	team,
	MAX(price_in_cr) AS max_price
FROM IPLPlayers
GROUP BY 1
)
SELECT p.player,p.team,p.price_in_cr
FROM IPLPlayers p
JOIN CTE c on p.team = c.team
WHERE P.price_in_cr = c.max_price
ORDER BY max_price desc


					----- CHATgbt-----
					
SELECT player,team,price_in_cr
FROM IPLPlayers
WHERE price_in_cr =(

		 SELECT
		 MAX(price_in_cr) as max_price
		 FROM IPLPlayers p3
		 WHERE p3.team = IPLPlayers.team
		
)
ORDER BY price_in_cr desc



----- Q4 Rank players by their price with in each team and list the top 2 for every team

with ranked_players as (
SELECT 
	player,
	team,
	price_in_cr,
ROW_NUMBER() OVER(PARTITION BY team ORDER BY price_in_cr desc) AS RANK_WITH_NUMBER
FROM IPLPlayers
) 
SELECT player,team,price_in_cr,RANK_WITH_NUMBER
FROM ranked_players
WHERE RANK_WITH_NUMBER <=2

----- Q5 Find the most expensive player from each team, along with the second most expensive player's name and price 

with ranked_players as (
SELECT 
	player,
	team,
	price_in_cr,
ROW_NUMBER() OVER(PARTITION BY team ORDER BY price_in_cr desc) AS RANK_WITH_NUMBER
FROM IPLPlayers
) 

SELECT team,
		MAX(CASE WHEN RANK_WITH_NUMBER = 1 THEN player END  ) as Most_Expensive_Player,
		MAX(CASE WHEN RANK_WITH_NUMBER = 1 THEN price_in_cr END  ) as Highest_price,
		MAX(CASE WHEN RANK_WITH_NUMBER = 2 THEN player END  ) as Second_Most_Expensive_Player,
		MAX(CASE WHEN RANK_WITH_NUMBER = 2 THEN price_in_cr END  ) as Second_Highest_price
FROM ranked_players
GROUP BY team


---- Q6 Calculate the percentage contribution of each player's price to their team's total spending 

SELECT 
    player,
	team,
	price_in_cr,
	price_in_cr /SUM(price_in_cr) OVER (PARTITION BY team ) * 100 as Contribution_percentage
FROM IPLPlayers


---- Q7 Classify players as high medium and low priced based on the following rules :
-- High price 15 
-- Medium price between 5 and 15 
-- Low price 5 
-- And find out the number of players in each bracket 


WITH CTE_BR AS (
	SELECT 
	     team,
		 player,
		 price_in_cr,
	CASE
		WHEN price_in_cr > 15 THEN 'High' 
		WHEN price_in_cr BETWEEN 5 AND 15 THEN 'Medium'
		ELSE 'Low'
		END AS price_category
	FROM IPLPlayers 	 
	)
SELECT 	
      team,
	  price_category, COUNT(*) AS No_of_players
FROM CTE_BR
GROUP BY 1,2 
ORDER BY 1,2


---- Q8 Find the average price of indian players and compare it with overseas players using a subquery


SELECT 
	'Indian' as player_type,
	(SELECT 
		AVG(price_in_cr) 
	FROM IPLPlayers
	WHERE type_players LIKE 'Indian%')AS avg_price 

UNION ALL
SELECT 
	'Overseas' as player_type,
	(SELECT 
		AVG(price_in_cr) 
	FROM IPLPlayers
	WHERE type_players LIKE 'Overseas%') AS avg_price 



------ Q9 Identify players who earn more than the average price of their team 


SELECT * 
FROM IPLPlayers;

SELECT 
	player,
	team,
	price_in_cr
FROM IPLPlayers pl
WHERE price_in_cr >
		(SELECT 
			AVG(price_in_cr)
		FROM IPLPlayers
		WHERE team = pl.team)


------ Q10 For each role find the most expensive player and their price using a correlated subquery


SELECT 
	player,
	team,
	role_players,
	price_in_cr
FROM IPLPlayers pl
WHERE price_in_cr = (

			SELECT 
				MAX(price_in_cr)
			FROM IPLPlayers 
			WHERE role_players = pl.role_players
			)




