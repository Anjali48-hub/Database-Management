/*by pg395*/
USE Spring_2018_Baseball;

/*1.	Create a domain (or one of the MS SQL equivalent functions) for the positions on a team.  If you’re using a domain, the domain name must start with your NJIT ID#.*/

CREATE TYPE PG395_Position FROM VARCHAR(5);
GO
/*a.	Modify the starting position in the AllStarFull  and Fielding tables to use the domain  (or equivalent) you created*/

ALTER TABLE AllStarFull
ALTER COLUMN startingPos PG395_Position;

ALTER TABLE Fielding
ALTER COLUMN POS PG395_Position;

GO

/*b.	Explain the reason to use a domain (or equivalent) vs. a constraint

*********** Explaination ***********:

The main and basic reason to use domainn over a constraint is that, even though both, domain and constraint can be applied to several columns, we need to change a constraint on every column if there is some change required in the column. But for a Domain, that is not the case. If there is a change required in a Domain and when it is done, it shows up the change everywhere that Doamin is used.*/


/*2.	You are concerned about the integrity of the database and want to restrict changing data to a user named NJITID_maintenance and read/select only rights to a user NJITID_information. Write the SQL to create the IDs and change the attributes for these 2 users to implement your plan for maintaining integrity. What would you do if you wanted to create another ID that would be the only one that modify the database schema.*/

CREATE LOGIN PG395_maintenance 
    WITH PASSWORD = 'pg395njit2018';
GO
/*Now, we create a database user for the above created login.*/
CREATE USER PG395_maintenance FOR LOGIN PG395_maintenance;
GO

CREATE LOGIN PG395_information
    WITH PASSWORD = 'pg395njit2018';
GO

/*Now, we create a database user for the above created login.*/
CREATE USER PG395_information FOR LOGIN PG395_information;
GO

/* We now change the attributes to the users for maintaining database integrity*/
ALTER ROLE db_datawriter ADD MEMBER PG395_maintenance;

ALTER ROLE db_datareader ADD MEMBER PG395_information;

GO


/* Now we create a new user and then transfer the schema authorization to that new user */

CREATE LOGIN PG395_SchemaAuthor
    WITH PASSWORD = 'pg395njit2018';
GO

-- Creates a database user for the login created above.
CREATE USER PG395_SchemaAuthor FOR LOGIN PG395_SchemaAuthor;
GO

ALTER ROLE db_owner ADD MEMBER PG395_SchemaAuthor;


/*3.	Write SQL to create roles that would allow you to create the same plan as question 3 for maintaining integrity. The role names must start with your NJIT ID */


CREATE ROLE PG395_RoleInformation;
GRANT SELECT TO PG395_RoleInformation;

CREATE ROLE PG395_RoleMaintenance;
GRANT SELECT, INSERT, DELETE, UPDATE TO PG395_RoleMaintenance;


/*4.	Create a role that has no other access than to read/select the view you created in question 1. The role name should be NJITID_Viewonly*/

CREATE ROLE PG395_Viewonly;
GRANT SELECT ON PG395_Player_History TO PG395_Viewonly;


 
