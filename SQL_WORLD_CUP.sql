
--The dataset was used is from MAVEN ANALYTICS 
-------- DATA TILL THE 2014 WORLD CUP
SELECT * FROM 

SELECT * from WorldCupMatches

SELECT  * from WorldCupPlayers

-------------------------------------------------------------------------
          --DATA CLEANING 
-------------------------------------------------------------------------
select * from WorldCupMatches


select  * from WorldCupPlayers

SELECT DISTINCT YEAR FROM WorldCupMatches	
--
UPDATE WorldCupMatches
SET Winners ='Argentina'
where Winners = ' Argentina'

UPDATE WorldCupS_preview
SET Winner ='Germany'
where Winner = 'GERMANY FR'

UPDATE WorldCupMatches
SET [Away Team Initials] ='GER'
where [Away Team Initials] = 'FRG'

UPDATE WorldCupPlayers
SET [Team Initials] = 'GER'
WHERE [Team Initials] = 'FRG'

UPDATE WorldCupPlayers
SET [Player Name] ='MULLER'
where [Player Name] = 'Mï¿½LLER'

UPDATE WorldCupPlayers
SET [Player Name] ='T.MULLER'
where [Player Name] = 'MULLER' AND [Coach Name] =  'LOEW Joachim (GER)'

UPDATE WorldCupPlayers
SET [Player Name] ='Lothar MATTHAEUS'
where [Player Name] = 'MATTHIUS' AND [Shirt Number] =  8

-------------------------------------------------------------------------
                -- Analysis based on questions provided.
-------------------------------------------------------------------------



--How has attendance trended over time? (both average per game and total per year)

-- total attendance each year from 1930 to 2014
select year,sum(Attendance) as total_attendance
from WorldCupMatches
group by Year	
order by 1 desc

-- avg attendance per match.

select Stage, avg(attendance) as avg_attent
from WorldCupMatches
group by stage

-----------------------------------------------------------

-- Do certain cities tend to draw bigger crowds?
select City, avg(attendance) as avg_attent
from WorldCupMatches
group by City
order by 2 desc  -- football loving states or cities tends to attract more attendance

--Do certain teams see larger attendance?

select [Home Team Name], avg(attendance) as avg_attent
from WorldCupMatches
group by [Home Team Name]
order by 2 desc

-- attendance of the current top 10 teams in the world throughout the years

select Winners,AVG(attendance) as_avg_attend
from WorldCupMatches
where Winners in ('Brazil','Belgium',
'France',
'Netherlands',
'Spain',
'Italy',
'Portugal',
'England',
'Argentina',
'Denmark')
group by Winners
order by 2 desc 


select year,Winners,sum(Attendance) as total_attendance
from WorldCupMatches
where Winners in ('Brazil','Belgium',
'France',
'Netherlands',
'Spain',
'Italy',
'Portugal',
'England',
'Argentina',
'Denmark')
group by Year,Winners	
order by 1 desc -- L
--------------
--------------

--Which teams have won the most games? 
SELECT WINNERS,COUNT(Winners) AS times_won
FROM WorldCupMatches
WHERE Winners != 'DRAW'
GROUP BY Winners
order by 2 desc


--How has number of wins by country trended over time?

SELECT WINNERS,Year,COUNT(Winners) AS times_won
FROM WorldCupMatches
WHERE Winners != 'DRAW' --and Winners in(
--'Netherlands',
--'Spain',
--'Italy',
--'Portugal',
--'England',
--'Argentina',
--'Denmark') 
GROUP BY year,Winners
order by 3 desc -- L


------------------------
--Based on the Home Team and Away Team columns, does there seem to be a "home team advantage"?


alter table WorldCupMatches
add home_or_away_wins varchar(255)

update WorldCupMatches
set home_or_away_wins = case when Winners = [Home Team Name] then 'home'
else 'away'
end

SELECT case when home_or_away_wins = 'home' then count(home_or_away_wins) 
	else count(home_or_away_wins) 
	end as away_and_home_wins
from WorldCupMatches
group by home_or_away_wins
	 
--> Home Wins = 505 and Away Wins = 347



---Do any teams seem to be stronger in either the first half or the second half? (think about both offense and defense)


with goal_ratio (Winners,half_time_g,full_time_g) as 
				
				(SELECT Winners,SUM([Half-time Home Goals]) half_time_g,sum([Home Team Goals]) full_time_g
				from WorldCupMatches
				where winners != 'draw'
				group by Winners)

SELECT winners,half_time_g,full_time_g-half_time_g as second_half_g,full_time_g
from goal_ratio
order by 4 desc

--> MOST TEAMS TEND TO BE STRONGER IN THE SECOND HALF OF THE MATCH.

------------How about the longest careers?


SELECT  distinct wc.[Player Name],wp.year,
ROW_NUMBER() over(partition by wc.[Player Name] order by wc.[Player Name]) number_world_cups_palyed
from WorldCupPlayers wc left join WorldCupMatches wp on
wc.MatchID = wp.MatchID
group by wc.[Player Name],wp.Year
order by number_world_cups_palyed desc

---> Antonio CARBAJAL and Lothar MATTHAEUS have had the longest carrers, having played 5 world_cups each.

----- TEAMS WITH THE MOST WORLD CUPS

select winner,count(winner) most_wc
from WorldCups_preview
group by winner
order by 2 desc

--- finals 
select distinct w.Year,w.[Home Team Name],w.[Away Team Name],[Home Team Goals],[Away Team Goals],Winner
from WorldCups_preview p join WorldCupMatches w
on p.Winner = w.Winners
where w.Stage = 'final'


---Biggest score lines losses
 
with scores as (select *, concat([Home Team Goals],'-',[Away Team Goals]) as score_line
from WorldCupMatches)

select top 5 Year, winners,score_line,[Away Team Name] as losing_team
from scores
where winners != 'draw' 
order by 3 desc

SELECT Year, Country host, Winner
FROM WorldCups_preview  
-----------------------------------------------------------------------------------------------------------------------
