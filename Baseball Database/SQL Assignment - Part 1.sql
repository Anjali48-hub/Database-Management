/*by pg395*/
USE Spring_2018_Baseball;
/*1.	Using the Salaries table, select playerid, yearid and salary. Remember to format the salary using the format command.*/
Select yearID, playerID, format(salary,'c') as salary
	From Salaries;


/*2.	Modify the query in #1 so it also shows a monthly salary (salary divided by 12). Rename the derived column Monthly Salary*/
Select yearID, playerID, format(salary,'c') as salary, format(salary/12,'c') as Monthly_Salary
	From Salaries;


/*3.	Provide a list of the teamids in the Salaries tables listing each team once.*/
Select distinct teamID
	From Salaries;


/*4.	Select the Teamid, PlayerID and Salary from the Salaries table for all players with salaries over $1 million dollars.*/
Select t.teamID, t.yearID,s.playerID, FORMAT(s.salary,'c') as salary
From Teams t, Salaries s
Where t.teamID = s.teamID and
t.yearID = s.yearID and 
t.lgID = s.lgID and 
s.salary > 1000000;


/*5.	Modify the query for #4 to show the same information for players on the New York Yankees.*/
Select t.teamID, t.yearID,s.playerID, FORMAT(s.salary,'c') as salary
From Teams t, Salaries s
Where t.teamID = 'NYA' and
t.teamID = s.teamID and
t.lgID = s.lgID and 
t.yearID = s.yearID and 
s.salary > 1000000; 


/*6.	Modify the query in #4 to show the players first and last name in addition to the information already shown. You will need to use the Master and Salaries tables with the correct join.*/
Select t.teamID, t.yearID,s.playerID, m.nameFirst, m.nameLast, FORMAT(s.salary,'c') as salary
From Teams t, Salaries s, Master m
Where s.playerID= m.playerID and
t.teamID = s.teamID and
t.yearID = s.yearID and 
t.lgID = s.lgID and 
s.salary > 1000000; 


/*7.	Modify the query for #4 again, but this time show the FranchName from the teamsFranchise table instead of the teamid. For this query, you must use the Master, Salaries, Teams and TeamsFranchises with the appropriate joins*/
Select tf.franchName, t.yearID, s.playerID, FORMAT(s.salary,'c') as salary
From Teams t, Salaries s, TeamsFranchises tf
Where t.franchID = tf.franchID and
t.teamID = s.teamID and
t.yearID = s.yearID and 
t.lgID = s.lgID and 
s.salary > 1000000;


/*8.	Using the MASTER table. List the first, last and given name for all players that use their initials as their first name (Hint: nameFirst contains at least 1 period(.) Also, concatenate the nameGiven, nameFirst and nameLast into a single column called Full Name putting the nameFirst in parenthesis. For example: James (Jim) Markulic*/
Select nameFirst, nameLast, nameGiven, nameGiven + ' (' + nameFirst + ') ' + nameLast as FullName
From Master
Where nameFirst like '%.%';


/*9.	Modify the query in #8 by adding the Salaries table and only show players who’s name does not contain a period (.) ad who played in 2000 and had a salary between $400,000 and $500,000. The salary in your results must be properly formatted showing dollars and cents. The results must also be sorted by Salary and then Last Name. You must use a BETWEEN clause in you with statement.*/
Select m.nameFirst, m.nameLast, m.nameGiven, m.nameGiven + ' (' + m.nameFirst + ') ' + m.nameLast as FullName, FORMAT(salary,'c') as salary
From Salaries s, Master m
Where s.playerID = m.playerID and
s.yearID = 2000 and 
s.salary between 400000 and 500000  and 
m.nameFirst NOT like '%.%'
order by s.salary, m.nameLast;


/*10.	Using the appropriate Set Operator (slide 32) and the MASTER and APPEARANCES tables, list the player, full name (as shown in #8 & 9) and the teamid of players who were in the appearances table for 2000 but not for 2001. */
Select m.playerID, m.nameGiven + ' (' + m.nameFirst + ') ' + m.nameLast as FullName, ap.teamID
From Master m, ((select playerID, teamID from Appearances where yearID=2000) 
				except 
				(select playerID, teamID from Appearances where yearID=2001)) ap
Where ap.playerID = m.playerID;


/*11.	Modify the query in #10 to use the appropriate Set Operator to show players who are in the appearances table for 2000 and 2001*/
Select m.playerID, m.nameGiven + ' (' + m.nameFirst + ') ' + m.nameLast as FullName, ap.teamID
From Master m, ((select playerID, teamID from Appearances where yearID=2000) 
				intersect 
				(select playerID, teamID from Appearances where yearID=2001)) ap
Where ap.playerID = m.playerID;


/*12.	Write one query to calculate the averages salary in the Salaries table using the formula Average Salary = sum(salaries)/count(playerid) and a second query using the average aggregate function. Explain the difference in the results.*/
Select FORMAT(SUM(salary)/COUNT(playerID),'C') as Avegrage_Using_Formula, 
       FORMAT(AVG(salary),'C') as Aggregate_Average_Function
From Salaries;


/*13.	Using the Salaries table and the appropriate aggregate function, calculate the average salary by teamid sorted by teamid*/
Select teamID, FORMAT(AVG(salary),'C') as Average_Salary
From Salaries
Group by teamID
Order by teamID;


/*14.	Using the Salaries table and the appropriate aggregate function, calculate the average salary by lgid and teamid sorted by lgid and teamid*/
Select lgID, teamID, FORMAT(AVG(salary),'C') as Average_Salary
From Salaries
Group by lgID, teamID
Order by lgID, teamID;


/*15.	Using the Salaries table and the appropriate aggregate function, calculatethe average salary by lgid and teamid sorted by lgid and teamid for 2015*/
Select lgID, teamID, FORMAT(AVG(salary),'C') as Average_Salary
From Salaries
Where yearID = 2015
Group by lgID, teamID
Order by lgID, teamID;