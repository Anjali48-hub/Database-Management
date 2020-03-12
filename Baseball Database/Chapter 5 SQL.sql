USE Spring_2018_Baseball;

/*1.	Using the Salary table, Write a query that ranks the players by salary (highest to lowest) for the year 2000*/
Select teamID, playerID, FORMAT(salary,'C') as Y2K_Salary,
RANK() Over (Order by salary Desc) as Salary_Rank
From Salaries
Where yearID = 2000;

/*2.	Write the same query as #2 but eliminate any gaps in the ranking */
Select teamID, playerID, FORMAT(salary,'C') as Y2K_Salary,
DENSE_RANK() Over (Order by salary Desc) as Salary_Rank
From Salaries
Where yearID = 2000;

/*3.	Write the same query as #3, but find the ranking within each team*/
Select teamID, playerID, FORMAT(salary,'C') as Y2K_Salary,
DENSE_RANK() Over (Partition by teamID Order by salary Desc) as Salary_Rank
From Salaries
Where yearID = 2000;

/*4.	Write the same query as #3, but show the ranking by quartile*/
Select teamID, playerID, FORMAT(salary,'C') as Y2K_Salary,
NTILE(4) Over (Order by salary Desc) as Salary_Rank
From Salaries
Where yearID = 2000;


/*5.	Using the Batting table , submit the SQL to find the rank of batting averages in 2011 (using the RANK SQL statement). Batting Averages are calculated using the Batting table. Batting Average should be calculated as (R+H)/AB columns. */
Select playerID, teamID, lgID, CASE When AB > 0 Then FORMAT((H+R)*1.0/AB,'N3') END as Batting_Avg, 
RANK() Over (Partition by lgID
Order by CASE When AB > 0 Then (H+R)*1.0/AB END Desc) as Batting_Rank
From Batting 
Where yearID = 2011
Order by Batting_Rank;




/*6.	Using the Salaries table, write a query that compares the averages salary by team and year with the running average of the current year and the next 3 years using the over and partition parameters.*/
Select S.teamID, S.yearID, FORMAT(S.AvgSal,'C') as Year_Average,
FORMAT(AVG(S.AvgSal) Over (Partition by teamID Order by yearID 
ROWS BETWEEN Current Row AND 3 following),'C') as Moving_Salary
From (Select teamID, yearID, AVG(salary) as AvgSal 
From Salaries 
Group by teamID, yearID) S