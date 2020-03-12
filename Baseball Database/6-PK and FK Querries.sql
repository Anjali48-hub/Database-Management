/*by pg395*/
USE Spring_2018_Baseball
/*In the beginning, we create Primary Keys*/

/*First, we change playerID in Master Table from  null to not null, making it the primary key*/
ALTER TABLE Master 
ALTER COLUMN playerID VARCHAR(255) NOT NULL;

ALTER TABLE Master 
ADD CONSTRAINT PK_Master PRIMARY KEY(playerID);



/*Now we change yearID,lgID, teamID in the teams table from null to not null and then make it the primary key*/
ALTER TABLE Teams 
ALTER COLUMN yearID int not null; 

ALTER TABLE Teams 
ALTER COLUMN lgID VARCHAR(255) not null;

ALTER TABLE Teams 
ALTER COLUMN teamID VARCHAR(255) not null;

ALTER TABLE Teams 
ADD CONSTRAINT PK_Teams PRIMARY KEY(yearID,lgID,teamID);



/*We change schoolID to not null and make it the primary key*/
ALTER TABLE Schools 
ALTER COLUMN schoolID VARCHAR(255) not null;
 
ALTER TABLE Schools 
ADD CONSTRAINT PK_Schools PRIMARY KEY(schoolID);



/*We change franchID to not null and making primary key in TeamFranchises*/
ALTER TABLE TeamsFranchises 
ALTER COLUMN franchID VARCHAR(255) not null;

ALTER TABLE TeamsFranchises 
ADD CONSTRAINT PK_TeamsFranchises PRIMARY KEY(franchID);



/*We change parkKey to not null and make it the primary key*/
ALTER TABLE Parks 
ALTER COLUMN park_key VARCHAR(255) not null; 

ALTER TABLE Parks 
ADD CONSTRAINT PK_Parks PRIMARY KEY (park_key); 



/*Making a primary key for Hall of Fame table*/
ALTER TABLE HallOfFame 
ADD CONSTRAINT PK_HallOfFame PRIMARY KEY (playerID,yearID,votedBy); 

/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/


/*Now, we create Foreign Keys*/
/* Make playerID from AllstarFull as the foreign key*/
ALTER TABLE AllstarFull 
ADD CONSTRAINT FK_AllstarFull_playerID_Master FOREIGN KEY(playerID) REFERENCES Master (playerID);



/*We make yearID, lgID, teamID in AllstarFull as foreign key*/
ALTER TABLE AllstarFull 
ADD CONSTRAINT FK_AllstarFull_yearID_lgID_teamID_Teams FOREIGN KEY(yearID, lgID, teamID) REFERENCES Teams (yearID, lgID, teamID);




/*We make playerID in CollegePlaying as foreign key*/
ALTER TABLE CollegePlaying 
ADD CONSTRAINT FK_CollegePlaying_playerID_Master FOREIGN KEY(playerID) REFERENCES Master (playerID);



/*We make schoolID in CollegePlaying as foreign key ------- (A)*/
ALTER TABLE CollegePlaying 
ADD FOREIGN KEY(schoolID) REFERENCES Schools (schoolID);

/*The above Query gives an error. So to resolve the error, we write a query to find out the uncommon records from schoolID columns in CollegePlaying and Schools Tables*/
select distinct(c.schoolID) from CollegePlaying c
where c.schoolID not in (select s.schoolID from Schools s);

/*Now, we inserted the uncommon records into the School table and we again fire the query (A). It now runs successfully.*/
insert into Schools (schoolID, name_full, city, state, country) values ('caallia',' ',' ',' ',' ');
insert into Schools (schoolID, name_full, city, state, country) values ('ctpostu',' ',' ',' ',' ');
insert into Schools (schoolID, name_full, city, state, country) values ('txrange',' ',' ',' ',' ');
insert into Schools (schoolID, name_full, city, state, country) values ('txutper',' ',' ',' ',' ');



/*We make franchID in Teams as foreign key*/
ALTER TABLE Teams 
ADD CONSTRAINT FK_Teams_franchID_TeamsFranchises FOREIGN KEY(franchID) REFERENCES TeamsFranchises (franchID);



/*We make lgID as forign key for Teams*/
ALTER TABLE Teams 
ADD CONSTRAINT FK_Teams_lgID_League FOREIGN KEY(lgID) REFERENCES League (lgID);



/*We make park_key as forign key for table HomeGames*/
ALTER TABLE HomeGames 
ADD CONSTRAINT FK_HomeGames_parkID_Parks FOREIGN KEY(parkID) REFERENCES Parks (park_key);



/*We make playerID as foriegn key in Appearances */
ALTER TABLE Appearances 
ADD CONSTRAINT FK_Appearances_playerID_Master FOREIGN KEY(playerID) REFERENCES Master (playerID);



/*We make yearID, LgID, teamID as foriegn key in Appearances */
ALTER TABLE Appearances 
ADD CONSTRAINT FK_Appearances_yearID_lgID_teamID_Teams FOREIGN KEY(yearID, lgID, teamID) REFERENCES Teams (yearID, lgID, teamID);



/*We make playerID as foriegn key in Batting */
ALTER TABLE Batting 
ADD CONSTRAINT FK_Batting_playerID_Master FOREIGN KEY(playerID) REFERENCES Master (playerID);



/*We make yearID, LgID, teamID as foriegn key in Batting */
ALTER TABLE Batting 
ADD CONSTRAINT FK_Batting_yearID_lgID_teamID_Teams FOREIGN KEY(yearID, lgID, teamID) REFERENCES Teams (yearID, lgID, teamID);



/*We make playerID as foriegn key in Salaries ------- (B)*/
ALTER TABLE Salaries 
ADD CONSTRAINT FK_Salaries_playerID_Master FOREIGN KEY(playerID) REFERENCES Master (playerID);

/*The above Query gives an error. So to resolve the error, we write a query to find out the uncommon records from playerID columns in Salaries and Master Tables*/
select distinct (sal.playerID) from Salaries sal
where sal.playerID not in (select m.playerID from Master m);



/*Now, we insert the uncommon records into the Master table and we again fire the query (B). It now runs successfully.*/
insert into Master(playerID)
select distinct playerID from Salaries sal
where sal.playerID not in(select m.playerID from Master m);



/*We make yearID, LgID, teamID as foriegn key in Salaries */
ALTER TABLE Salaries 
ADD CONSTRAINT FK_Salaries_yearID_lgID_teamID_Teams FOREIGN KEY(yearID, lgID, teamID) REFERENCES Teams (yearID, lgID, teamID);



/*We make playerID as foriegn key in Managers */
ALTER TABLE Managers 
ADD CONSTRAINT FK_Manager_playerID_Master FOREIGN KEY(playerID) REFERENCES Master (playerID);



/*We make yearID, LgID, teamID as foriegn key in Managers */
ALTER TABLE Managers 
ADD CONSTRAINT FK_Manager_teamID_Teams FOREIGN KEY(yearID, lgID, teamID) REFERENCES Teams (yearID, lgID, teamID);



/*We make lgID as foriegn key in AwardsManagers */
ALTER TABLE AwardsManagers 
ADD CONSTRAINT FK_AwardsManagers_lgID_League FOREIGN KEY(lgID) REFERENCES League (lgID);



/*We make playerID as foriegn key in AwardsManagers */
ALTER TABLE AwardsManagers 
ADD CONSTRAINT FK_AwardsManagers_playerID_Master FOREIGN KEY(playerID) REFERENCES Master (playerID);



/*We make playerID as foriegn key in HallOfFame  --------(D)*/
Alter table HallOfFame 
ADD CONSTRAINT FK_HallOfFame_playerID_Master FOREIGN KEY (playerID) REFERENCES Master(playerID);



/*The above Query gives an error. So to resolve the error, we write a query to find out the uncommon records from playerID columns in HallOfFame and Master Tables and again execute the above query and it executes successfully*/
select distinct (hf.playerID) from HallOfFame hf
where hf.playerID not in (select m.playerID from Master m);

/*Now, we insert the uncommon records into the Master table and we again fire the query (D). It now runs successfully.*/
insert into Master(playerID)
select distinct playerID from HallOfFame hf
where hf.playerID not in(select m.playerID from Master m);


/*We make playerID as foriegn key in Pitching*/
ALTER TABLE Pitching
ADD CONSTRAINT FK_Pitching_playerID_Master FOREIGN KEY (playerID) REFERENCES Master(playerID);



/*We make yearID, lgID and teamID as foriegn key in Pitching*/
ALTER TABLE Pitching
ADD CONSTRAINT FK_Pitching_yearID_lgID_teamID_Teams FOREIGN KEY (yearID, lgID, teamID) REFERENCES Teams(yearID, lgID, teamID);



/*We make yearID, LgID, teamID as foriegn key in HomeGames*/
ALTER TABLE HomeGames
ADD CONSTRAINT FK_HomeGames_yearID_lgID_teamID_Teams FOREIGN KEY (yearID, lgID, teamID) REFERENCES Teams(yearID, lgID, teamID);



/*We make playerID as foriegn key in AwardsPlayers*/
ALTER TABLE AwardsPlayers
ADD CONSTRAINT FK_AwardsPlayers_playerID_Master FOREIGN KEY (playerID) REFERENCES Master(playerID);



/*We make playerID as foriegn key in Fielding*/
ALTER TABLE Fielding
ADD CONSTRAINT FK_Fielding_playerID_Master FOREIGN KEY (playerID) REFERENCES Master(playerID);



/*We make yearID, LgID, teamID as foriegn key in Fielding*/
ALTER TABLE Fielding
ADD CONSTRAINT FK_Fielding_yearID_lgID_teamID_Teams FOREIGN KEY (yearID, lgID, teamID) REFERENCES Teams(yearID, lgID, teamID);



/*We make playerID as foriegn key in FieldingOf*/
ALTER TABLE FieldingOF
ADD CONSTRAINT FK_FieldingOf_playerID_Master FOREIGN KEY (playerID) REFERENCES Master(playerID);



/*We make playerID as foriegn key in AwardsSharePlayers*/
ALTER TABLE AwardsSharePlayers
ADD CONSTRAINT FK_AwardsSharePlayers_playerID_Master FOREIGN KEY (playerID) REFERENCES Master(playerID);



/*We make playerID as foriegn key in AwardsShareManagers*/
ALTER TABLE AwardsShareManagers
ADD CONSTRAINT FK_AwardsShareManagers_playerID_Master FOREIGN KEY (playerID) REFERENCES Master(playerID);



/*We make LeagueID as foriegn key in AwardsShareManagers   ------- (C)*/
ALTER TABLE AwardsShareManagers
ADD CONSTRAINT FK_AwardsShareManagers_leagueID_Leagues FOREIGN KEY (lgID) REFERENCES League(lgID);




/*We insert some records in the League table*/
INSERT INTO League (lgID,teamID,yearID,playerID,W,L,PCT,GB,HOME,ROAD,RS,RA,DIFF,STRK,L10,POFF) values('NA','CH1',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ');
INSERT INTO League (lgID,teamID,yearID,playerID,W,L,PCT,GB,HOME,ROAD,RS,RA,DIFF,STRK,L10,POFF) values('NL','CL2',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ');
INSERT INTO League (lgID,teamID,yearID,playerID,W,L,PCT,GB,HOME,ROAD,RS,RA,DIFF,STRK,L10,POFF) values('AA','BL2',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ');
INSERT INTO League (lgID,teamID,yearID,playerID,W,L,PCT,GB,HOME,ROAD,RS,RA,DIFF,STRK,L10,POFF) values('AL','BLA',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ');
INSERT INTO League (lgID,teamID,yearID,playerID,W,L,PCT,GB,HOME,ROAD,RS,RA,DIFF,STRK,L10,POFF) values('FL','CHF',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ');
INSERT INTO League (lgID,teamID,yearID,playerID,W,L,PCT,GB,HOME,ROAD,RS,RA,DIFF,STRK,L10,POFF) values('PL','NYP',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ');
INSERT INTO League (lgID,teamID,yearID,playerID,W,L,PCT,GB,HOME,ROAD,RS,RA,DIFF,STRK,L10,POFF) values('ML','MYP',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ');
INSERT INTO League (lgID,teamID,yearID,playerID,W,L,PCT,GB,HOME,ROAD,RS,RA,DIFF,STRK,L10,POFF) values('UA','UAA',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ');
/*Initially, there were no records in theLeague table. Hence, (C) could not be executed and we got an eror. 
  But after inserting some records in the League table (C) executes successfully */



/*We make lgID as foriegn key in AwardsSharePlayers*/
ALTER TABLE AwardsSharePlayers
ADD CONSTRAINT FK_AwardsSharePlayers_lgID_League FOREIGN KEY (lgID) REFERENCES League(lgID);


/*The above Query gives an error. So to resolve the error, we write a query to find out the uncommon records from lgID columns in AwardsSharePlayers and League Tables and again execute the above query and it executes successfully.*/
select distinct (asp.lgID) from AwardsSharePlayers asp
where asp.lgID not in (select l.lgID from League l);



/*We make lgID as foriegn key in AwardsPlayers*/
ALTER TABLE AwardsPlayers
ADD CONSTRAINT FK_AwardsPlayers_lgID_League FOREIGN KEY (lgID) REFERENCES League(lgID);


/*The above Query gives an error. So to resolve the error, we write a query to find out the uncommon records from lgID columns in AwardsPlayers and League Tables and again execute the above query and it executes successfully*/
select distinct (ap.lgID) from AwardsPlayers ap
where ap.lgID not in (select l.lgID from League l);



/*We make lgID as foriegn key in Managers*/
ALTER TABLE Managers
ADD CONSTRAINT FK_Managers_lgID_League FOREIGN KEY (lgID) REFERENCES League(lgID);


/*The above Query gives an error. So to resolve the error, we write a query to find out the uncommon records from lgID columns in Managers and League Tables and again execute the above query and it executes successfully*/
select distinct (mn.lgID) from Managers mn
where mn.lgID not in (select l.lgID from League l);

/*We make lgID as foriegn key in Salaries*/
ALTER TABLE Salaries
ADD CONSTRAINT FK_Salaries_lgID_League FOREIGN KEY (lgID) REFERENCES League(lgID);



/*We make lgID as foriegn key in HomeGames*/
ALTER TABLE HomeGames
ADD CONSTRAINT FK_HomeGames_lgID_League FOREIGN KEY (lgID) REFERENCES League(lgID);


/*The above Query gives an error. So to resolve the error, we write a query to find out the uncommon records from lgID columns in HomeGames and League Tables and again execute the above query and it executes successfully*/
select distinct (hg.lgID) from HomeGames hg
where hg.lgID not in (select l.lgID from League l);

/*We make lgID as foriegn key in Appearances*/
ALTER TABLE Appearances
ADD CONSTRAINT FK_Appearances_lgID_League FOREIGN KEY (lgID) REFERENCES League(lgID);


/*The above Query gives an error. So to resolve the error, we write a query to find out the uncommon records from lgID columns in Appearances and League Tables and again execute the above query and it executes successfully*/
select distinct (ap.lgID) from Appearances ap
where ap.lgID not in (select l.lgID from League l);

/*We make lgID as foriegn key in Batting*/
ALTER TABLE Batting
ADD CONSTRAINT FK_Batting_lgID_League FOREIGN KEY (lgID) REFERENCES League(lgID);


/*The above Query gives an error. So to resolve the error, we write a query to find out the uncommon records from lgID columns in Batting and League Tables and again execute the above query and it executes successfully*/
select distinct (b.lgID) from Batting b
where b.lgID not in (select l.lgID from League l);

/*We make lgID as foriegn key in Fielding*/
ALTER TABLE Fielding
ADD CONSTRAINT FK_Fielding_lgID_League FOREIGN KEY (lgID) REFERENCES League(lgID);
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*It is beneficial to create a League table as a separate table for futher use. Hence, we creare the same.*/

USE Spring_2018_Baseball
GO

IF OBJECT_ID (N'dbo.League', N'U') IS NOT NULL
DROP TABLE dbo.League;
GO
			
CREATE TABLE League(
lgID VARCHAR(255), 
teamID VARCHAR(255),
yearID INTEGER,
playerID VARCHAR(255),
W VARCHAR(255),
L VARCHAR(255),
PCT VARCHAR(255),
GB VARCHAR(255),
HOME VARCHAR(255),
ROAD VARCHAR(255),
RS  VARCHAR(255),
RA VARCHAR(255),
DIFF VARCHAR(255),
STRK VARCHAR(255),
L10 VARCHAR(255),
POFF VARCHAR(255),

PRIMARY KEY (lgID) 
);
GO










