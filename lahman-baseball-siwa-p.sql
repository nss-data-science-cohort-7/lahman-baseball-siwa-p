-- 1. Find all players in the database who played at Vanderbilt University. 
-- Create a list showing each player’s first and last names as well as the total salary they earned in the major leagues.
-- Sort this list in descending order by the total salary earned. 
-- Which Vanderbilt player earned the most money in the majors?


SELECT p.namefirst, p.namelast, SUM(sa.salary) as salary
FROM people as p
LEFT JOIN (
	SELECT DISTINCT playerid, schoolid
	FROM collegeplaying as col
)
USING (playerid)
LEFT JOIN schools as s
USING (schoolid)
LEFT JOIN salaries as sa
USING (playerid)
WHERE sa.salary IS NOT NULL AND s.schoolname = 'Vanderbilt University'
GROUP BY p.playerid
ORDER BY salary DESC;


/*
Test to see if I get the same salary for David Price

SELECT playerid, SUM(salary)
FROM salaries
where playerid = 'priceda01'
GROUP BY playerid

*/


-- playerid have multiple entries from collegeplaying 


-- DAVID PRICE earned the most money in the majors

-- 2). Using the fielding table, group players into three groups based on their position: 
-- label players with position OF as “Outfield”, those with position “SS”, “1B”, “2B”, and “3B” as 
-- “Infield”, and those with position “P” or “C” as “Battery”. Determine the number of putouts made 
-- by each of these three groups in 2016.

WITH d as (SELECT
        po,
        CASE 
            WHEN pos = 'OF' THEN 'Outfield'
            WHEN pos IN ('SS', '1B', '2B', '3B') THEN 'Infield'
		   	WHEN pos IN ('P', 'C') THEN 'Battery'
            --ELSE 'neither'
        END AS pos
    FROM
        fielding)
SELECT pos, SUM(po)
FROM d
GROUP BY pos
ORDER BY SUM(po) DESC;

/*
"Infield"	6101378
"Outfield"	2731506
"Battery"	2575499
*/

-- Year is 2016 : Use this


/*
Find the average number of strikeouts per game by decade since 1920. 
Round the numbers you report to 2 decimal places. Do the same for home runs per game. 
Do you see any trends? 
*/

-- SO in pitching table don't need another table
-- want to average by generating bins 

/*
WITH bins as (
		SELECT generate_series(1920, 2016, 10) AS Decade
				)
SELECT Decade, trunc(SUM(p.so),2) as avg_so
FROM bins
LEFT JOIN pitching as p
ON p.yearid < Decade

GROUP BY Decade
ORDER BY Decade DESC;
*/


WITH bins AS (
    SELECT generate_series(1920, 2010, 10) AS lower,
           generate_series(1930, 2020, 10) AS upper)
SELECT 
	lower AS decade, 
	ROUND(SUM(sto.so * 1.0)/SUM(ghome * 1.0), 2) AS avg_strikeouts,  
	ROUND(SUM(sto.hr * 1.0)/SUM(ghome * 1.0), 2) AS avg_homeruns     
FROM teams as sto
   LEFT JOIN bins AS b
       ON yearid >= lower
       AND yearid < upper
GROUP BY decade
ORDER BY decade;

-- By Mariel



-- SO is the average homeruns

/*
Find the player who had the most success stealing bases in 2016, where success is measured as the percentage of 
stolen base attempts which are successful.(A stolen base attempt results either in a stolen base or being caught stealing.) 
Consider only players who attempted at least 20 stolen bases. 
Report the players’ names, number of stolen bases, number of attempts, and stolen base percentage.
*/

-- STOLEN BASE ATTEMPT = SUM ( STOLEN BASES, CAUGHT STEALING)
WITH base_table AS (
SELECT p.namefirst, p.namelast, SUM(b.sb) AS stolen_bases, SUM(b.cs) AS caught_stealing
FROM people as p
INNER JOIN batting as b
USING(playerid)
WHERE b.cs IS NOT NULL AND b.sb IS NOT NULL AND b.yearid = '2016'
GROUP BY (p.playerid)
)

SELECT namefirst, 
		namelast,
		stolen_bases, 
		caught_stealing, 
		(stolen_bases + caught_stealing) AS Total_attempt, 
		concat(round(100.0*stolen_bases/(stolen_bases+caught_stealing),2),'%') AS stolen_base_percentage
		
FROM base_table
WHERE (stolen_bases+caught_stealing) >= 20
ORDER BY stolen_base_percentage DESC;

/*
From 1970 to 2016, what is the largest number of wins for a team that did not win the world series? 
What is the smallest number of wins for a team that did win the world series? 
Doing this will probably result in an unusually small number of wins for a world series champion; determine why this is the case. 
Then redo your query, excluding the problem year. 
How often from 1970 to 2016 was it the case that a team with the most wins also won the world series? 
What percentage of the time?
*/

-- WSWIN  in teams table
-- W  is wins in teams table
-- L is losses
select teamid,
    SUM(CASE 
		WHEN wswin = 'Y' THEN 1
		ELSE 0
	END) AS win_ws
from teams
group by teamid
ORDER BY win_ws DESC;










