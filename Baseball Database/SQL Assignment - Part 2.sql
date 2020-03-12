/*by pg395*/
Use Spring_2018_Baseball;

/*1.	Using the Salaries table and the appropriate aggregate functions, calculate the average salary by lgid, teamid and team name sorted by lgid and teamid for 2015*/

Select t.lgID, t.teamID, t.name, FORMAT(AVG(sal.salary),'C') as Average_Salary
From Salaries sal, Teams t
Where sal.lgID = t.lgID and
sal.teamID = t.teamID and
sal.yearID = t.yearID and 
sal.yearID = 2015 
Group by t.lgID, t.teamID, t.name
Order by t.lgID, t.teamID;




/*2.	Using the Master and Salaries tables along with the appropriate aggregate functions list the playerid, names (in nameGiven (nameFirst) nameLast format) and average salary for all players who had a salary greater than $400,000. You must use a HAVING clause to handle the salary condition and your answer must be sorted by playerid.*/

Select  sal.playerID, ms.nameGiven + ' (' + ms.nameFirst + ') ' + ms.nameLast as Name, FORMAT(AVG(sal.salary),'C') as Average_Salary
From Salaries sal, Master ms 
Where sal.playerID = ms.playerID and
sal.playerID IN (Select playerID
From Salaries
Group by playerID
Having SUM(salary) > 400000)
Group by sal.playerID, ms.nameGiven + ' (' + ms.nameFirst + ') ' + ms.nameLast
Order by sal.playerID;




/*3.	Use a nested subquery and an IN statement in the WHERE Clause to find all players who played in 2010 and 2015. Your results should show the playerid, full name, teamid and team name. */

Select distinct ms.playerID, ms.nameGiven + ' (' + ms.nameFirst + ') ' + ms.nameLast as Player_Name, t.teamID, t.name
From Master ms, Teams t, Appearances a
Where t.teamID = a.teamID and
t.yearID = a.yearID and
t.lgID = a.lgID and
a.yearID IN (2010,2015) and
ms.playerID = a.playerID and
ms.playerID IN ((select playerID from Appearances where yearID=2010) 
		        intersect 
			   (select playerID from Appearances where yearID=2015));




/*4.	Using the Salaries table, a nested subquery similar to that in #3 and a SOME clause to find the list of players on the NY Yankees and their salary that have a salary higher than at least one other player on the team in 2014*/

Select playerID, teamID, yearID, FORMAT(salary,'C') as Salary
From Salaries
Where teamID = 'NYA' and
yearID = 2014 and
salary > SOME (Select salary 
From Salaries 
Where yearID = 2014 and 
teamID = 'NYA');




/*5.	Using the Salaries table, select the team name, minimum, average and maximum salary for all teams in the AL league in 2015*/

Select t.lgID, t.name, FORMAT(MIN(sal.salary),'C') as Minimum_Salary, FORMAT(AVG(sal.salary),'C') as Average_Salary, FORMAT(MAX(sal.salary),'C') as Maximum_Salary
From Teams t, Salaries sal
Where sal.yearID = t.yearID and
sal.teamID = t.teamID and
sal.lgID = t.lgID and
sal.lgID = 'AL' and
sal.yearID = 2015
Group by t.lgID, t.name;




/*6.	Using the Salaries table, a HAVING clause, and a subquery similar to that used in the question #4, find the teamids and average salary of the teams with and average salary greater than the average salary of the NY Mets in 2010 */

Select t.teamID, FORMAT(AVG(sal.salary),'C') as Average_Salary
From Teams t, Salaries sal
Where 	t.yearID = sal.yearID and
t.teamID = sal.teamID and
t.lgID = sal.lgID and
sal.yearID = 2010
Group by t.teamID
Having AVG(sal.salary) > (Select AVG(Salary)
From Salaries 
Where teamID = 'NYN' and 
yearID = 2010);




/*7.	Using the Master, Teams and Appearances tables, list the play name and team name of all players playing on the same team in 2010 and 2015. You must use a nested query in your answer. */

Select ms.nameLast + ', ' + ms.nameFirst as Player_name, t.name as Team_name 
From Master ms, Teams t, ((select playerID, teamID from Appearances where yearID=2010) 
					     intersect 
						 (select playerID, teamID from Appearances where yearID=2015)) a
Where t.teamID = a.teamID and
ms.playerID = a.playerID;




/*8.	Using an All clause and a subquery using the Salaries table, find the names of all players who played in 2016 and had a salary higher than all the players who played in 2013. */

Select ms.nameLast + ', ' + ms.nameFirst as Player_Name, t.name as Team_Name
From Salaries sal, Master ms, Teams t
Where t.yearID = sal.yearID and 
t.teamID = sal.teamID and
t.lgID = sal.lgID and
sal.playerID = ms.playerID and
sal.yearID = 2016 and
sal.salary > ALL (Select distinct salary 
From Salaries 
Where yearID = 2013);




/*9.	Using a WITH clause to calculate the average salary by team for 2012, find the names of all the player, their salaries and the difference between their salary and the average salary of their team who played in 2012. */

With Avg_Sal AS (Select sal.teamID, t.name, AVG(salary) as SalAvg
From Salaries sal, Teams t 
Where sal.yearID = t.yearID and 
sal.teamID = t.teamID and 
sal.lgID = t.lgID and
 sal.yearID = 2012
Group by sal.teamID, t.name)
Select a.name as Team_Name, ms.nameLast + ', ' + ms.nameFirst as Player_Name, FORMAT(salary,'C') as Salary, FORMAT((salary - SalAvg),'C') as Difference
From Salaries sal, Master ms, Avg_Sal a
Where a.teamID = sal.teamID and
sal.playerID = ms.playerID and
sal.yearID = 2012
GO




/*10.	Using WITH statements to create 3 subqueries (one each for the Manager Win %, Team Win % and Team Names, find the managers who’s win percent (total of W/total of G) for all the years they managed is greater that the win percentage of all the years for that teams.  */

With Manager_details 
	as
(Select m1.teamID, t.name as Team_Name, m1.playerID, ms.nameLast + ', ' + ms.nameFirst as Manager,
		(Select SUM(W*1.0)/SUM(G)
		From Managers mn
		Where m1.playerID = mn.playerID) as Win_Percent ,
		(Select SUM(W*1.0)/SUM(G)
		From Teams t1
		Where t1.teamID = t.teamID) as Team_Win_Percent
From Managers m1, Master ms, Teams t
Where	m1.playerID = ms.playerID and
		m1.teamID = t.teamID and
		m1.yearID = t.yearID and
		m1.lgID = t.lgID and
		m1.plyrMgr = 'Y')

Select distinct Team_Name, Manager, FORMAT(Win_Percent,'P') as Manager_Percent, 
		FORMAT(Team_Win_Percent,'P') as Team_Percent, 
		FORMAT(Win_Percent - Team_Win_Percent,'P') as Per_Difference
From Manager_details
Where Win_Percent > Team_Win_Percent
Order by Team_Name
GO




/*11.	Using a scalar query using the Appearances table and the Master table, find the number of teams each player played for. */

Select ms.nameLast + ', ' + ms.nameFirst as Player_Name, (Select COUNT(*) 
From (Select playerID, teamID 
From Appearances a
Group by playerID, teamID) aa
Where ms.playerID = aa.playerID) as '# of Teams' 
From Master ms;
GO




/*12.	Add a column to the MASTER table named NJITID_Avg_Salary (NJITID is your NJIT ID such as JM234_Avg_Salary) and write a query that will calculate the player’s average salary and update the new column with that information. Your SQL should use an IF and GO statements to check and see if the new column exists before adding it. After updating the information in the new column, write a query that shows the player name and the value in the new column you created. Exclude the players where the salary information is null. You will need to use the Master and Salaries tables for this problems.*/

IF COL_LENGTH('Master','PG395_Avg_Salary') is NULL
BEGIN
Alter Table Master ADD PG395_Avg_Salary money;
END;

UPDATE Master 
Set PG395_Avg_Salary = (Select 
CASE When AVG(salary) is NOT NULL Then AVG(salary) 
Else 0
END
From Salaries sal
Where Master.playerID = sal.playerID);

Select ms.nameLast + ', ' + ms.nameFirst as Player_Name, FORMAT(PG395_Avg_Salary,'C') as Average_Salary
From Master ms;


/*The data requested in the example could be achieved by the following query:*/
Select ms.nameLast + ', ' + ms.nameFirst as Player_Name, FORMAT(SUM(sal.salary),'C') as Total_Salary
From Master ms, Salaries sal
Where ms.playerID = sal.playerID
Group by ms.nameLast + ', ' + ms.nameFirst
Order by ms.nameLast + ', ' + ms.nameFirst;




/*13.	The player’s new contract says that each team must contribute to a player’s 401K retirement account. The contract says 10% of the salary must be put in the 401K for players making under $2 million dollars and 5% for players making $2 million and above.  Create a column (with the appropriate IF and GO statement) in the Salaries table named NJITID_401K (NJITID is your NJIT ID such as JM234_401K) and write a query to populate the data from all past yearsal. Use a CASE clause to update the column using the correct percentage. Also write a query to show the playerid, salary and 401K amount for each year. You will need to use only the Salaries table for this problems.*/

IF COL_LENGTH('Salaries','PG395_401K') is NULL
BEGIN
Alter Table Salaries ADD PG395_401K money
END;
 
UPDATE Salaries
Set PG395_401K = (Select CASE When salary < 2000000 Then (salary * 10 / 100)
When salary >= 2000000 Then (salary * 5 / 100)
END);

Select playerID, yearID, FORMAT(salary,'C') as Salary, FORMAT(PG395_401K,'C') as Amount_401K
From Salaries sal;




/*14.	Using the Master and Salaries tables, show the playerID, full names as formatted below and birthdates (properly formatted) and salary  for any Yankee(NYA) playing in 1990 whose salary is greater than the salary of any Boston Red Sox (BOS) using the salaries and mater tables sort highest to lowest salary*/

Select sal.playerID, ms.nameGiven + ' (' + ms.nameFirst + ') ' + ms.nameLast as 'Full Name', 
CONVERT(varchar(10),(Convert(char(02),ms.birthMonth) + '/' + Convert(char(02),ms.birthDay) + '/' + 
CONVERT (char(04),ms.birthYear)),101) as 'Birth Day', FORMAT(salary,'C') as 'NYA Salary'
From Master ms, Salaries sal
Where ms.playerID = sal.playerID and
sal.yearID = 1990 and
sal.salary > ANY (Select distinct salary 
From Salaries 
Where teamID = 'BOS' and 
yearID = 1990)
Order by 'NYA Salary' Desc;




/*15.	Using only the Master table for this problems. Players are inducted into the Hall of Fame on July 7th each year. Calculate the exact age (using days, months and years) of the players when they were inducted into the Hall of Fame. You will need to use a CONVERT function to properly combine the 3 date columns to get a derived column you can use in the required calculation. To get the exact age, you will need to use a DATEDIFF function using the month and then convert the months to years to get the exact age. Your results should have the playerID, Full Name, Birth Year, Inducted Year, Full Birth Date (in the proper format), Full Induction Date (in the proper format) and the age in yearsal. */

Select ms.playerID, ms.nameFirst + ' ' + ms.nameLast as 'Player Name', ms.birthYear, hf.yearID, hf.category,
d.calcdate, d.inductdate, DATEDIFF(MONTH,d.calcdate,d.inductdate)/12 as Age
From Master ms, HallOfFame hf, 
(Select ms.playerID, CONVERT(char(10),(Convert(char(02),birthMonth) + '-' + 
Convert(char(02),birthDay) + '-' + 
Convert(char(04),birthYear)),110) as calcdate,
CONVERT(char(10),('07-07-' + Convert(char(04),yearID)),110) as inductdate
From Master ms, HallOfFame hf 
where ms.playerID = hf.playerID and hf.inducted = 'Y') as d
Where ms.playerID = hf.playerID and
d.playerID = hf.playerID and
hf.inducted = 'Y' 