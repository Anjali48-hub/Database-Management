/*by pg395*/
/*Create and populate a column called  NJITID_Total_Salary and populate it with the sum of all salaries for each player. Next, write a trigger that updates the NJITID_ Total_Salary attribute you created in the master table whenever there is a new row added to the salary table or whenever a salary is updated. The trigger name must start with your NJITID and the DDL that creates the trigger must also check to see if the trigger exists before creating it.*/

USE Spring_2018_Baseball;

/*First we create and populate a column called  PG395_Total_Salary and populate it with the sum of all salaries for each player.*/ 
IF COL_LENGTH('Master','PG395_Total_Salary') is NULL
BEGIN
	Alter Table Master ADD PG395_Total_Salary money
END;
 
UPDATE Master
	Set PG395_Total_Salary = (Select CASE When SUM(salary) is not NULL Then SUM(salary)
											Else 0 END
						  From Salaries s
							  Where s.playerID = Master.playerID);

/*Now we write a trigger that updates the PG395_ Total_Salary attribute created in the master table whenever there is a new row added to the salary table or whenever a salary is updated.*/
IF OBJECT_ID ('PG395-Salary_MOD','TR') IS NOT NULL
BEGIN
   DROP TRIGGER PG395_Salary_MOD
END

CREATE TRIGGER PG395_Salary_MOD ON Salaries 
AFTER INSERT, UPDATE
AS
Begin 

/*This updates PG395_Total_Salary column in Master table for all player records inserted or updated in Salaries table */
	UPDATE Master Set PG395_Total_Salary = (Select SUM(x.salary)
												From (Select * from Salaries sal
														Where sal.playerID IN (Select playerID
																				From inserted)) x
												Group by x.playerID)
	Where Master.playerID IN (Select playerID From inserted);

/*This updates PG395_Avg_Salary column in Master table for all player records inserted or updated in Salaries table */
	UPDATE Master Set PG395_Avg_Salary = (Select AVG(x.salary)
												From (Select * from Salaries sal
														Where sal.playerID IN (Select playerID
																				From inserted)) x
												Group by x.playerID)
	Where Master.playerID IN (Select playerID From inserted);

/*This updates PG395_401K column in Salaries table for all player records inserted or updated in Salaries table */
	UPDATE Salaries Set PG395_401K = (Select CASE When salary < 2000000 Then salary * 0.10
												  When salary >= 2000000 Then salary * 0.05 
											 END)
	Where Convert(varchar,Salaries.yearID) + Salaries.teamID + Salaries.lgID + Salaries.playerID 
		IN (Select Convert(varchar,yearID) + teamID + lgID + playerID From inserted);
End;
			
/*Now we write the queries necessary to verify your trigger works correctly.*/

/*Here, we can view data for 'abercda01' in Master and Salaries table before Insert into Salaries table */
Select playerID, PG395_Avg_Salary, PG395_Total_Salary from Master where playerID = 'abercda01';
Select * from Salaries where playerID = 'abercda01';

INSERT Into Salaries(yearID, teamID, lgID, playerID, salary) Values(2007, 'CIN', 'NL', 'abercda01', 323000);
INSERT Into Salaries(yearID, teamID, lgID, playerID, salary) Values(2008, 'CIN', 'NL', 'abercda01', 50000);
INSERT Into Salaries(yearID, teamID, lgID, playerID, salary) Values(2009, 'CIN', 'NL', 'abercda01', 200000);
INSERT Into Salaries(yearID, teamID, lgID, playerID, salary) Values(2010, 'CIN', 'NL', 'abercda01', 250000);
INSERT Into Salaries(yearID, teamID, lgID, playerID, salary) Values(2011, 'CIN', 'NL', 'abercda01', 350000);

/*We can view the data for 'abercda01' in Master and Salaries table (a) after Insert, and (b) before Update into Salaries table */
Select playerID, PG395_Avg_Salary, PG395_Total_Salary from Master where playerID = 'abercda01';
Select * from Salaries where playerID = 'abercda01';

UPDATE Salaries Set salary = salary * 1.10 
				where yearID <> 2006 and playerID = 'abercda01';

/*Finally, we can view data for 'abercda01' in Master and Salaries table after Update into Salaries table */
Select playerID, PG395_Avg_Salary, PG395_Total_Salary from Master where playerID = 'abercda01';
Select * from Salaries where playerID = 'abercda01';