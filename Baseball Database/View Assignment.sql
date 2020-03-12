/*by pg395*/

CREATE VIEW PG395_Player_History 
					(playerID, Player_Name, #_of_Teams_played_for, #_of_Years_played,
								Total_Salary, Average_Salary, Name_of_last_college_attended,
								Year_Last_played_in_College, #_of_Years_attended_college, 
								#_of_different_colleges_played_for, Year_last_played, 
								Name_of_last_Team_played_for, Last_Year_played_in_AllStars,
							    ID_of_Last_team_played_in_AllStars, Name_of_Last_Team_played_in_AllStars, 
								Last_league_in_AllStars, Last_Position_played_in_AllStars, 
								Year_of_highest_Batting_Average, Highest_Batting_Average,
								Name_of_the_Team_of_Highest_batting_Average, Total_num_of_Home_runs,
								#_of_Years_as_Manager, #_of_distinct_Teams_Managed,
								Average_percent_wins_as_manager, Year_of_highest_percent_wins, 
								Team_of_highest_percent_wins) 
					
					
					AS





WITH player_data AS
  (SELECT mas.playerID, (mas.nameFirst + ' ( ' + mas.nameGiven + ' ) '+ mas.nameLast) AS PlayerName,
	(SELECT count(*) FROM (SELECT playerID, teamid FROM Appearances GROUP BY playerID,teamID) app 
		WHERE mas.playerID = app.playerID) AS #_of_teams_played, 
	(SELECT max(yearID) - min(yearID) + 1 FROM Appearances ap	
			WHERE mas.playerID = ap.playerID) AS #_of_Yrs_played FROM Master mas),




salary_data AS 
  (SELECT DISTINCT sal.playerID, FORMAT(SUM(sal.salary),'C') AS Total_Salary, 
	FORMAT(AVG(sal.salary),'C') AS Avg_Salary FROM Salaries sal GROUP BY playerID),



college_data AS
  (SELECT DISTINCT Cp.playerID, sch.name_full AS Last_Clg, cc.last_played_year,cc.#_of_years, 
	(SELECT COUNT(*) FROM (SELECT playerID, schoolID FROM CollegePlaying GROUP BY playerID, schoolID) cp
		WHERE cc.playerID = cp.playerID) AS #_of_Colleges_played FROM CollegePlaying Cp, 
	(SELECT c.playerID, MAX(c.yearID) AS last_played_year,
		(MAX(c.yearID) - MIN(c.yearID) + 1) AS #_of_years FROM CollegePlaying c
		GROUP BY playerID) cc, Schools sch
	WHERE Cp.playerID = cc.playerID and
	sch.schoolID = Cp.schoolID and	Cp.yearID = cc.last_played_year),




career_data AS
  (SELECT ap.playerID, y.last_played_year, tm.name as last_team_played_for FROM Appearances ap,
	(SELECT a.playerID, MAX(a.yearID) AS last_played_year FROM Appearances a GROUP BY a.playerID) y, Teams tm WHERE
	ap.playerID = y.playerID 
	and ap.lgID = tm.lgID
	and ap.yearID = tm.yearID 
	and ap.teamID = tm.teamID  
	and ap.yearID = y.last_played_year),




allstar_data AS
(SELECT DISTINCT a.playerID, a.yearID AS last_year_played_AllStars, a.teamID AS last_AllStars_TeamID, 
tm.name AS last_AllStars_Team_name, a.lgID AS last_AllStars_lgID, a.startingPos AS last_AllStars_Pos
FROM AllstarFull a, 
	(SELECT a.playerID, max(a.yearID) AS Last_Year_played_in_AllStars FROM AllstarFull a
		GROUP BY playerID) als, Teams tm
	WHERE a.playerID = als.playerID and
	tm.teamID = a.teamID and
	tm.yearID = a.yearID and
	tm.lgID = a.lgID and
	a.yearID = als.Last_Year_played_in_AllStars),



batting_data AS
(SELECT bt.playerID, bt.yearID AS Highest_Bat_Avg_Yr, bt.Batting_Avg AS Highest_Bat_Avg, 
bt.teamID AS Highest_Bat_Avg_Team,bat.Total_Home_Run FROM 
	(SELECT *, H*1.0/AB AS Batting_Avg FROM Batting WHERE AB > 0) bt, 
		(SELECT bavg.playerID, MAX(bavg.Bat_Avg) AS Highest_bat_Avg,SUM(bavg.HR) AS Total_Home_Run
			FROM (SELECT *, H*1.0/AB AS Bat_Avg FROM Batting WHERE AB > 0) bavg
			GROUP BY bavg.playerID) bat, Teams tm
WHERE bt.playerID = bat.playerID and
	bt.Batting_Avg = bat.Highest_bat_Avg and
	bt.teamID = tm.teamID and
	bt.yearID = tm.yearID and
	bt.lgID = tm.lgID),



manager_data AS
(SELECT mn1.playerID, mng.#_of_Years_as_Mgr,
	(SELECT COUNT(*) FROM (SELECT playerID, teamID FROM Managers
						  WHERE plyrMgr = 'Y' GROUP BY playerID, teamID) mn
	WHERE mn1.playerID = mn.playerID) AS #_of_teams_managed,
FORMAT(mng.Avg_WR,'P') AS Avg_Win_Percent,mn1.yearID AS Max_Mgr_win_prcnt_year,
tm.name AS Max_Mgr_win_prcnt_team FROM Teams tm, 
	(SELECT *,(W*1.0/G) AS Win_ratio FROM Managers WHERE plyrMgr = 'Y') mn1,
	(SELECT playerID, MAX(yearID) - MIN(yearID) + 1 AS #_of_Years_as_Mgr,
		AVG(Win_ratio) AS Avg_WR, MAX(Win_ratio) AS Max_WR 
		FROM (SELECT *,(W*1.0/G) AS Win_ratio FROM Managers WHERE plyrMgr = 'Y') mm
		GROUP BY playerID) mng
WHERE mn1.playerID = mng.playerID and
mn1.yearID = tm.yearID and
mn1.teamID = tm.teamID and
mn1.lgID = tm.lgID and 
mn1.Win_ratio = mng.Max_WR)



	
	(SELECT pldt.playerID, pldt.playerName, pldt.#_of_teams_played, pldt.#_of_Yrs_played, 
						sd.Total_salary, sd.Avg_salary, cd.Last_Clg, cd.last_played_year, 
						cd.#_of_years, cd.#_of_Colleges_played, cad.last_played_year, 
						cad.last_team_played_for, ad.last_year_played_AllStars, ad.Last_AllStars_lgID, ad.Last_AllStars_TeamID,
						ad.Last_AllStars_Team_name,	ad.Last_AllStars_Pos, bd.Highest_Bat_Avg_Yr,
						bd.Highest_Bat_Avg, bd.Highest_Bat_Avg_Team, bd.Total_Home_Run,
						md.#_of_teams_managed, md.#_of_Years_as_Mgr, md.Avg_Win_Percent,
						md.Max_Mgr_win_prcnt_team, md.Max_Mgr_win_prcnt_year
				FROM player_data pldt left outer join salary_data sd on pldt.playerID = sd.playerID 
									left outer join college_data cd on pldt.playerID = cd.playerID
									left outer join career_data cad on pldt.playerID = cad.playerID
									left outer join allstar_data ad on pldt.playerID = ad.playerID
									left outer join batting_data bd on pldt.playerID = bd.playerID
									left outer join manager_data md on pldt.playerID = md.playerID
				);

GO
SELECT * FROM PG395_Player_History;






