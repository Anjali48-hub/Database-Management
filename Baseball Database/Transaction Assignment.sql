Use Spring_2018_Baseball;
Print 'Sript Start Time - ' + (CAST(convert(varchar,getdate(),108) AS nvarchar(30)))
Set nocount Off;		/* Turn off record effected messages */
Set Statistics Time Off; /* Turn on Execution Time Statistics */

/* Run Simple Update Query To Get Time Without Transaction   */


/* Create Date Updated Column If IT Doesn't Exist            */
IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Appearances'
                 AND COLUMN_NAME = 'JM234_Last_Update')
	BEGIN
		alter table Appearances 
		add JM234_Last_Update date default NULL,
			JM234_SQL_Last_Update date default NULL,			
		    JM234_SQL_COUNT INT not null Default 0,
		    jm234_CURSOR_Count INT not null Default 0
	END;
go

/* Run Simple Update Query To Get Time Without Transaction Processing */
Declare		@today date
Set			@today = convert(date, getdate())
Print 'SQL Update Command Start Time - ' + (CAST(convert(varchar,getdate(),108) AS nvarchar(30)))
Update A 
	set JM234_SQL_Last_Update = (Select convert(date, getdate()-5))   /* Update to 5 days ago */
		from Appearances A INNER JOIN Salaries S ON A.playerid = S.playerid and
													A.Teamid = S.Teamid and
													A.LGID = S.LGID and
													A.Yearid = S.YearID
Update A 
	set A.JM234_SQL_Count = JM234_SQL_COUNT +1
		from Appearances A INNER JOIN Salaries S ON A.playerid = S.playerid and
													A.Teamid = S.Teamid and
													A.LGID = S.LGID and
													A.Yearid = S.YearID;

Print 'SQL Update Command End Time - ' + (CAST(convert(varchar,getdate(),108) AS nvarchar(30)))

Set Nocount On;       /* Turn Off Record Count Messages   */
-- Transaction SQL #1

Set nocount on;
--- Run Transaction
--- Update script
-- Declare variables
DECLARE     @updateCount bigint 
DECLARE     @YearID varchar(50)
DECLARE     @TeamID VARCHAR(50)
DECLARE     @LGID varchar(50)
DECLARE     @PlayerID varchar(50)
DECLARE		@STOP int
DECLARE		@ERROR INT
	
-- Initialize the update count
set @updateCount = 0
set @stop = 0

--Set @today = convert(date, getdate())
Print @today
Print 'Transaction Update Command Start Time - ' + (CAST(convert(varchar,getdate(),108) AS nvarchar(30)))
--- Declare Cursor
DECLARE updatecursor CURSOR STATIC FOR
        SELECT salaries.yearID, salaries.TeamID, salaries.LGID, salaries.PLayerid
            FROM Salaries, Appearances
			WHERE Salaries.yearid = appearances.yearid and
				salaries.lgid = appearances.LGID and
				salaries.teamid = Appearances.teamid and
				salaries.playerid = Appearances.playerid 
				AND (JM234_Last_Update <> @today or JM234_Last_Update is Null);
		Select @@CURSOR_ROWS as 'Number of Cursor Rows After Declare'
		Print 'Declare Cursor Complete Time - ' + (CAST(convert(varchar,getdate(),108) AS nvarchar(30)))
--- Open Cursor
    OPEN updatecursor
	Select @@CURSOR_ROWS as 'Number of Cursor Rows'
    FETCH NEXT FROM updatecursor INTO @yearID, @TeamID, @LGID, @PLayerid
    WHILE @@fetch_status = 0 AND @STOP = 0
    BEGIN
-- Begin transaction for the first record
    if @updateCount = 0
    BEGIN 
      PRINT 'Begin Transaction At Record - ' + RTRIM(CAST(@updateCount AS nvarchar(30))) + ' At - ' + (CAST(convert(varchar,getdate(),108) AS nvarchar(30)))
      BEGIN TRANSACTION
    END

---    PRINT 'UPDATE Salaries for key = ' + @yearID + @TeamID + @LGID + @PLayerid
Update Appearances
	set JM234_Last_Update = @today
	where @yearID = yearID AND
		 @TeamID = teamid AND
		 @LGID = LGID AND
		 @PLayerid = playerID;

Update Appearances 
	set JM234_Cursor_Count = JM234_Cursor_Count + 1
		where @yearID = yearID AND
		 @TeamID = teamid AND
		 @LGID = LGID AND
		 @PLayerid = playerID;
		 

   set @updateCount = @updateCount + 1
--- Abend at Record 17543
   IF @updateCount = 17543
	Begin
  	set @STOP = 1
	End

-- Commit every 10,000 records and start a new transaction
        IF @updateCount % 100 = 0 
        BEGIN
            PRINT 'COMMIT TRANSACTION - ' + RTRIM(CAST(@updateCount AS nvarchar(30))) + ' At - ' + (CAST(convert(varchar,getdate(),108) AS nvarchar(30)))

-- DONE WITH THE PREVIOUS GROUP, WE NEED THE NEXT
            PRINT 'END OLD TRANSACTION AT RECORD - ' + RTRIM(CAST(@updateCount AS nvarchar(30))) + ' At - ' + (CAST(convert(varchar,getdate(),108) AS nvarchar(30)))

            COMMIT TRANSACTION

            BEGIN TRANSACTION
        END
        FETCH NEXT FROM updatecursor INTO @yearID, @TeamID, @LGID, @PLayerid
    END
    IF @stop <> 1
    BEGIN
        -- COMMIT FINAL WHEN TO THE END
        PRINT 'Final Commit Transaction For Record - ' + RTRIM(CAST(@updateCount AS nvarchar(30))) + ' At - ' + (CAST(convert(varchar,getdate(),108) AS nvarchar(30)))

        COMMIT TRANSACTION
    END
	IF @stop = 1
    BEGIN
        -- Rollback to last COMMIT
        PRINT 'Rollback started For Transaction at Record - ' + RTRIM(CAST(@updateCount AS nvarchar(30))) + ' At - ' + (CAST(convert(varchar,getdate(),108) AS nvarchar(30)))

        Rollback TRANSACTION
    END

    CLOSE updatecursor
    DEALLOCATE updatecursor
Print 'Transaction Update Command End Time - ' + (CAST(convert(varchar,getdate(),108) AS nvarchar(30))) + ' At - ' + (CAST(convert(varchar,getdate(),108) AS nvarchar(30)))
set nocount off;
select count(JM234_Last_Update) as 'Count_CURSOR_Dates',
		count(JM234_SQL_LAST_UPDATE) as 'Count_SQL_Dates',
		sum(JM234_SQL_Count) as 'Sum_SQL_Counter',
		sum(JM234_CURSOR_COUNT) as 'Sum_CURSOR_Counter'
	from Appearances 