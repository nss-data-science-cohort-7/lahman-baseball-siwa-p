-- 1. Find all players in the database who played at Vanderbilt University. 
-- Create a list showing each player’s first and last names as well as the total salary they earned in the major leagues.
-- Sort this list in descending order by the total salary earned. 
-- Which Vanderbilt player earned the most money in the majors?


SELECT p.namefirst, p.namelast, sa.salary as salary
FROM people as p
LEFT JOIN collegeplaying as col
USING (playerid)
LEFT JOIN schools as s
USING (schoolid)
LEFT JOIN salaries as sa
USING (playerid)
WHERE sa.salary IS NOT NULL AND s.schoolname = 'Vanderbilt University'
ORDER BY salary DESC;


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
            ELSE 'neither'
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


/*
Find the average number of strikeouts per game by decade since 1920. 
Round the numbers you report to 2 decimal places. Do the same for home runs per game. 
Do you see any trends? 
*/

-- SO in pitching table don't need another table
-- want to average by generating bins 

WITH bins as (
		SELECT generate_series(1920, 2016, 10) AS Decade
				)
SELECT Decade, trunc(AVG(p.so),2) as avg_so
FROM bins
LEFT JOIN pitching as p
ON p.yearid < Decade

GROUP BY Decade
ORDER BY Decade DESC;

-- THE average number of strikeouts is increasing monotonously since 1990. 


WITH bins as (
		SELECT generate_series(1920, 2016, 10) AS Decade
				)
SELECT Decade, trunc(AVG(b.hr),2) as avg_hr
FROM bins
LEFT JOIN batting as b
ON b.yearid < Decade

GROUP BY Decade
ORDER BY Decade DESC;


-- SO is the average homeruns



