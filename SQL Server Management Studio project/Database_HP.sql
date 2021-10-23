/*
relations 
team:coach --> 1 team:N coaches ; 1 coach:M Teams =>  N:M --uses a connector table
player:team --> 1 player:1 team; 1 team:N players =>  1:N--uses the foreign key
coach:player --> NO RELATION

TABLES: player, team, coach, conn_coach_team
REFERENCES: player->team, conn->coach, conn->team
CREATE: team, player,coach(should be created before the connector table), conn
DROP: conn, coach, player, team (we should drop on the inverce order of the creation)
*/


IF object_id('conn_coach_team', 'U') is not null DROP TABLE conn_coach_team;
IF object_id('coach', 'U') is not null DROP TABLE coach;
IF object_id('player', 'U') is not null DROP TABLE player;
IF object_id('team', 'U') is not null DROP TABLE team;
GO

CREATE TABLE team(
     team_id int primary key,
	 team_name nvarchar(100) not null,
	 team_conference nvarchar(100),
	 team_foundationDate date,
	 team_championshipsWon int,
	 team_arena nvarchar(100)
)

CREATE TABLE player(
     player_id int primary key,
	 player_name nvarchar(100) not null,
	 player_age int,
	 player_position nvarchar(100),
	 player_height float,
	 player_weight float,
	 player_salary int,
	 player_fieldGoal float,
	 player_draftDate date,
	 player_team int NOT NULL references team(team_id)
)

CREATE TABLE coach(
     coach_id int primary key,
	 coach_name nvarchar(100) not null,
	 coach_type nvarchar(100),
	 coach_yearsOfExperience int,
	 coach_hireDate date,
	 coach_salary int,
	 coach_age int, 
	 coach_email nvarchar(100)
)

CREATE TABLE conn_coach_team(
     conn_id int identity primary key,
	 conn_coach int references coach(coach_id),
	 conn_team int references team(team_id)
)
GO

INSERT INTO team VALUES(1, 'Los Angeles Lakers', 'Western', '1947-10-06', 17, 'Staples Center') 
INSERT INTO team VALUES(2, 'Los Angeles Clippers', 'Western', '1970-09-30', 0, 'Staples Center') 
INSERT INTO team VALUES(3, 'Houston Rockets', 'Western', '1967-11-26', 2, 'Toyota Center') 
INSERT INTO team VALUES(4, 'Milwaukee Bucks', 'Eastern', '1968-05-07', 1,'Fiserv Forum') 
INSERT INTO team VALUES(5, 'Boston Celtics', 'Eastern', '1946-06-09', 17,'TD Garden');

--players : psoitions- 1 = point gueard (PG)
--                     2 = shooting guard (SG)
--                     3 = small forward (SF)
--                     4 = power forward (PF)
--                     5 = center (C)

INSERT INTO player VALUES(1, 'Lebron James', 35, 'PF', 2.06, 113.0, 37000000, 49.3,'2003-06-09', 1)
INSERT INTO player VALUES(2, 'Russell Westbrook', 27, 'PG', 1.90, 90.0, 38000000, 43.7,'2008-04-10', 3)
INSERT INTO player VALUES(3, 'George Hill', 34, 'PG', 1.90, 85.0, 8000000, 51.6,'2008-07-17', 4)
INSERT INTO player VALUES(4, 'James Harden', 31, 'SG', 1.96, 99.0, 38000000, 44.4,'2009-01-22', 3)
INSERT INTO player VALUES(5, 'Paul George', 30, 'SG', 2.03, 99.0, 33000000, 43.3,'2010-04-21', 2)
INSERT INTO player VALUES(6, 'Kawhi Leonard', 29, 'SF', 2.01, 102.0, 32000000, 49.1,'2011-03-14', 2)
INSERT INTO player VALUES(7, 'Anthony Davis', 27, 'C', 2.08, 114.0, 27000000, 50.3,'2012-10-15', 1)
INSERT INTO player VALUES(8, 'Giannis Antetokounmpo', 25, 'PF', 2.11, 109.0, 24000000, 55.3,'2013-02-03', 4)
INSERT INTO player VALUES(9, 'Jayson Tatum', 22, 'SF', 2.03, 95.0, 7000000, 45.0,'2017-12-03', 5)
INSERT INTO player VALUES(10, 'Tacko Fall', 24, 'C', 2.26, 141.0, 1000000, 78.6,'2019-01-30', 5);


INSERT INTO coach VALUES(1, 'Joseph Clanaghan', 'Handles coach', 10, '2019-06-05', 900000, 38, 'Josephclanaghan07@gmail.com')
INSERT INTO coach VALUES(2, 'James Cooper', 'Shooting coach', 15, '2018-03-16', 1500000, 40, 'Jamescooper3445@gmail.com')
INSERT INTO coach VALUES(3, 'Jacob Smith', 'Defense coach', 6, '2020-07-20', 5000000, 32, 'Jacobsmith867@gmail.com')
INSERT INTO coach VALUES(4, 'Theo Williams', 'Defense coach',8, '2019-11-23', 7000000, 37, 'Theowilliams34@gmail.com')
INSERT INTO coach VALUES(5, 'Marc Thompson', 'Handles coach',9, '2017-01-31', 8000000, 35, 'Marcthompson6541@gmail.com')
INSERT INTO coach VALUES(6, 'Harry Addams', 'Shooting coach',12, '2020-06-11', 1300000, 42, 'Marcthompson6541@gmail.com');

INSERT INTO conn_coach_team (conn_coach, conn_team) VALUES (1,1), (2,1), (2,2), (3,2), (3,3), (4,3), (4,4), (5,4), (5,5), (6,5);
GO

----------------------------------------------------------3 simple single-table select statements---------------------------------------------------------------
--Q1 => 
SELECT * FROM team;
--Q2 => 
SELECT * FROM conn_coach_team; 
--Q3 => 
SELECT * FROM coach;
--Q4 => 
SELECT * FROM player;

---------------------------------------------------------------3 simple single-table GROUP BY------------------------------------------------------------------------

--Q5 => List the number of teams belonging to each conference and the total number of championships won in each conference:

SELECT team_conference , count(team_id) as numberOfTeams, sum(team_championshipsWon) as championshipsWon
FROM team
GROUP BY team_conference;

--Q6 =>List the number of players for each position and the best and the worsefield goal on the current position:

SELECT player_position, count(player_id) as numberPerPosition, max(player_fieldGoal) bestFGperPosition, min(player_fieldGoal) worseFGperPosition
from player
group by player_position;


--Q7 => List the number of coaches accordingly to the type of coach and the average salary for each type:

SELECT coach_type, count(coach_id) as CoachNum, avg(coach_salary) as AVGsal
FROM coach
group by coach_type

---------------------------------------------------------------5 complex multi-table select-------------------------------------------------------------------------

--Q8 => List the  number of coaches for each team:

SELECT team_name, count(coach_id) as numCoach
from team inner join conn_coach_team on team_id = conn_team
          inner join coach on conn_coach = coach_id
group by team_name;

--Q9 => List the  number of players in each team:
SELECT team_name, count(player_id) as numbeOfPlayers, avg(player_fieldGoal) as AvgFGTeam
from player inner join team on player_team = team_id
group by team_name;

--Q10 => List the team name and the coach name working for them:

select team_name, coach_name 
from team 
          inner join conn_coach_team on (team_id = conn_team)
          inner join coach on (conn_coach = coach_id) 
order by team_name;

--Q11 => List the name of the players and the name of the team where they are playing for:

SELECT team_name, player_name
FROM player inner join team on player_team = team_id
order by team_name;

--Q12 => List the coach type that each teams are currently working with:

SELECT team_name, coach_type
FROM team inner join conn_coach_team on team_id = conn_team
          inner join coach on conn_coach = coach_id
ORDER BY team_name;

---------------------------------------------------------------5 complex subquery select------------------------------------------------------------------------------

--Q13/14 => Who are the oldest(veteran) and the most recent(rookie) players in the league?
if object_id('v1', 'v') is not null drop view v1;
go

create view v1 as
      select datediff(year, player_draftDate, GETDATE()) yearsInTheLeague
	  from player 
go

select player_name as Veteran, player_draftDate, (select max(yearsInTheLeague) from v1) as yearsInTheLeague
from (select player_name, player_draftDate from player) as subquery
order by player_draftDate
offset 0 rows
fetch first 1 row only;

select player_name as Rookie, player_draftDate, (select min(yearsInTheLeague) from v1) as yearsInTheLeague
from (select player_name, player_draftDate from player) as subquery
order by player_draftDate desc
offset 0 rows
fetch first 1 row only;

--Q15 => What was the longest interval of time(in years) that the NBA stayed without getting a new player in the league?

select max(subquery.intervalInYears) as intervalInYears
from (select datediff(year, p1.player_draftDate, p2.player_draftDate) as intervalInYears 
      from player p1 inner join player p2 on p1.player_id = p2.player_id - 1) as subquery;

--Q16 => How many years after the teams foundation did each of them hire one of their actual coach? how many coaches does each team  have?

select team_name, min(interval) as yearsAfterFoundation, count(coach_id) as CoachesHiredSinceThen
from (
      select coach_id, coach_hireDate, team_name, team_foundationDate, datediff(year, team_foundationDate, coach_hireDate) as interval
	  from team inner join conn_coach_team on team_id = conn_team
	            inner join coach on conn_coach = coach_id
	  order by coach_name offset 0 rows
) as subquery
group by team_name;

--Q17 => Considering this coaches, what age was the earlient that a coach got into the league?

select min(carrierStart) as carrierStart
from (
      select coach_yearsOfExperience, coach_age, (coach_age-coach_yearsOfExperience) as carrierStart
	  from coach
) as subquery;

---------------------------------------------------------------5 analyics/advanced grouping query---------------------------------------------------------------------

--Q18 => List the rank of the teams in the league accordingly to the championships won:

SELECT
DENSE_RANK() OVER(ORDER BY team_championshipsWon desc) AS RankInTheLeague, team_name as Name,team_championshipsWon as ChampionshipsWon, (select sum(team_championshipsWon)from team) as OutOf
FROM team
ORDER BY RankInTheLeague ASC;

--Q19 => List the rank of the better paid coaches in the league:

SELECT
DENSE_RANK() OVER(ORDER BY coach_salary desc) AS RankInTheLeague, coach_name as Name,coach_salary as Salary
FROM coach
ORDER BY RankInTheLeague ASC;

--Q20 => List the rank of the better paid players in the league:

SELECT
DENSE_RANK() OVER(ORDER BY player_salary desc) AS RankInTheLeague, player_name as Name,player_salary as Salary
FROM player
ORDER BY RankInTheLeague ASC;

--Q21 => How many players got draftet on the same month and year and also on the same year, what about in total?

select DATEPART(YEAR,player_draftDate) as 'Year', DATEPART(MONTH,player_draftDate)as 'Month',count(player_id)
from player inner join team on player_team = team_id
group by rollup(DATEPART(YEAR,player_draftDate), DATEPART(MONTH,player_draftDate));

--Q22 => What is the total amount spent to pay the players? how much exactly does each of the team pay for their players,
--and the average of the salary of the players on that team

select team_name, sum(player_salary) as TotalSpent, avg(player_salary) as AvgSalary
from player inner join team on player_team = team_id
group by rollup(team_name);

--------------------------------------------------------DML: 2 insert, 2 update, 2 delete(3 of those must implement subqueries)-------------------------------

--Q23 => Insert a random player in the league.

INSERT INTO player 
VALUES(11, 'Charles Gonçalves', Rand()*(30-20)+20, 'PG',
       ROUND(RAND()*(2.10-1.70)+1.70,1),
	   ROUND(RAND()*(85-65)+65,1),
	   RAND()*(15000000-5000000)+5000000,
	   ROUND(Rand()*(100-0)+0,1),'2003-06-09', Rand()*(5-1)+1);

select * from player inner join team on player_team = team_id where player_id = 11

--Q24 => Update the team table by adding a new column “jersey Color”

alter table team
add team_jerseyColor nvarchar(50)
go

update team
set team_jerseyColor = case team_id
                       when 1 then  'Black and Yellow'
					   when 2 then  'White, Red and Blue'
					   when 3 then  'Black and Red'
					   when 4 then  'Black and Green'
					   when 5 then  'White and Green'
				  end;
select team_name, team_jerseyColor 
from team;
go

--Q25 => List the player’s Name, Salary, draft date, by which team, and the years of waiting for the next draft:

if object_id('tableau', 'U') is not null drop table tableau;
go

create table tableau(
        Drafted nvarchar(50),
		DraftDate date,
		TeamName nvarchar(50),
		Salary int,
		YearsToNextDraft int
)

insert into tableau
select Drafted, DraftDate, team_name, salary, YearsToNextDraft
from (select p1.player_team as team, p1.player_name as Drafted,  p1.player_draftDate as DraftDate, datediff(year, p1.player_draftDate, p2.player_draftDate) as YearsToNextDraft,
             p1.player_salary as salary
      from player p1 inner join player p2 on p1.player_id = p2.player_id - 1) as subquery inner join team on team = team_id

select * from tableau;

--Q26 => Add the a column team_playOffMAde using Rand(), which Is equal to 1 if the team passed or 0 if the team didn’t pass to the playOffs

alter table team
add team_playOffMade nvarchar(50)
go

update team 
set team_playOffMade = case team_id
                       when 1 then Convert(nvarchar,floor( Rand()*(2 - 0) + 0))
					   when 2 then Convert(nvarchar,floor( Rand()*(2 - 0) + 0))
					   when 3 then Convert(nvarchar,floor( Rand()*(2 - 0) + 0))
					   when 4 then Convert(nvarchar,floor( Rand()*(2 - 0) + 0))
					   when 5 then Convert(nvarchar,floor( Rand()*(2 - 0) + 0))
					   end;

update team
set team_playOffMade = case team_playOffMade
                       when '0' then 'Did not make to the Play Off'
					   when '1' then 'Made to the PLay Off'
					   end;
select * from team;

--Q27 => All the players that belong to the teams that didn’t make to the play off should be deleted.

delete player
from player inner join team on player_team = team_id
where team.team_playOffMade = 'Did not make to the Play Off';
go

select team_name as remainingTeam, count(player_id) as players, avg(player_fieldGoal) as TeamFG
from player inner join team on player_team = team_id
group by team_name;

--Q28 => If at this stage there are still teams with 0 championships won, their players should be deleted from the table.

delete player
from player inner join team on player_team = team_id
where team.team_championshipsWon = 0;
go

select player_name, team_name, team_championshipsWon 
from player inner join team on player_team = team_id
order by team_championshipsWon desc;




