use nba_veritabani;

INSERT INTO Conference (ConferenceName)
SELECT DISTINCT Conference
FROM Staging_Data
WHERE Conference IS NOT NULL AND Conference != '';

INSERT INTO Team (TeamID, TeamName, TeamAbbreviation, LogoURL, ConferenceID)
SELECT
    s.TEAM_ID,
    MIN(s.TEAM_NAME_x) AS TeamName, -- Farklı isimler varsa birini seç
    MIN(s.TEAM_ABBREVIATION) AS TeamAbbreviation,
    MIN(s.Logo_URL) AS LogoURL,
    MIN(c.ConferenceID) AS ConferenceID
FROM Staging_Data s
JOIN Conference c ON s.Conference = c.ConferenceName
WHERE s.TEAM_ID IS NOT NULL
GROUP BY s.TEAM_ID; -- TeamID'ye göre grupla

INSERT INTO Player (PlayerID, PlayerName, Position, HeadshotURL, TeamID)
SELECT
    s.PLAYER_ID,
    MIN(s.PLAYER_NAME) AS PlayerName,
    MIN(s.POSITION) AS Position,
    MIN(s.HEADSHOT_URL) AS HeadshotURL,
    MIN(s.TEAM_ID) AS TeamID
FROM Staging_Data s
WHERE s.TEAM_ID IN (SELECT TeamID FROM Team)
  AND s.PLAYER_ID IS NOT NULL
GROUP BY s.PLAYER_ID; -- PlayerID'ye göre grupla

INSERT INTO TeamStats (
    TeamID, GP, W, L, W_PCT, MIN, DEF_RATING, DREB, DREB_PCT, STL, BLK,
    GP_RANK, W_RANK, L_RANK, W_PCT_RANK, MIN_RANK, DEF_RATING_RANK,
    DREB_RANK, DREB_PCT_RANK, STL_RANK, BLK_RANK
)
SELECT
    s.TEAM_ID,
    MIN(s.GP_y), MIN(s.W_y), MIN(s.L_y), MIN(s.W_PCT), MIN(s.MIN_y), MIN(s.DEF_RATING), MIN(s.DREB_y),
    MIN(s.DREB_PCT), MIN(s.STL_y), MIN(s.BLK_y), MIN(s.GP_RANK), MIN(s.W_RANK), MIN(s.L_RANK), MIN(s.W_PCT_RANK),
    MIN(s.MIN_RANK), MIN(s.DEF_RATING_RANK), MIN(s.DREB_RANK), MIN(s.DREB_PCT_RANK), MIN(s.STL_RANK), MIN(s.BLK_RANK)
FROM Staging_Data s
WHERE s.TEAM_ID IN (SELECT TeamID FROM Team)
GROUP BY s.TEAM_ID; -- TeamID'ye göre grupla

INSERT INTO OpponentStats (
    TeamID, OPP_PTS_OFF_TOV, OPP_PTS_2ND_CHANCE, OPP_PTS_FB, OPP_PTS_PAINT,
    OPP_PTS_OFF_TOV_RANK, OPP_PTS_2ND_CHANCE_RANK, OPP_PTS_FB_RANK, OPP_PTS_PAINT_RANK
)
SELECT
    s.TEAM_ID,
    MIN(s.OPP_PTS_OFF_TOV), MIN(s.OPP_PTS_2ND_CHANCE), MIN(s.OPP_PTS_FB), MIN(s.OPP_PTS_PAINT),
    MIN(s.OPP_PTS_OFF_TOV_RANK), MIN(s.OPP_PTS_2ND_CHANCE_RANK), MIN(s.OPP_PTS_FB_RANK), MIN(s.OPP_PTS_PAINT_RANK)
FROM Staging_Data s
WHERE s.TEAM_ID IN (SELECT TeamID FROM Team)
GROUP BY s.TEAM_ID; -- TeamID'ye göre grupla

INSERT INTO `Player Regular Season Performance`
    (PlayerID, GP, W, L, MIN, FGM, FGA, FG_PCT, FG3M, FG3A, FG3_PCT,
    FTM, FTA, FT_PCT, OREB, DREB, REB, AST, TOV, STL, BLK, BLKA, PF, PFD,
    PTS, PLUS_MINUS, Efficiency)
SELECT
    s.PLAYER_ID, s.GP_x, s.W_x, s.L_x, s.MIN_x, s.FGM, s.FGA, s.FG_PCT,
    s.FG3M, s.FG3A, s.FG3_PCT, s.FTM, s.FTA, s.FT_PCT, s.OREB, s.DREB_x,
    s.REB, s.AST, s.TOV, s.STL_x, s.BLK_x, s.BLKA, s.PF, s.PFD,
    s.PTS, s.PLUS_MINUS, s.Efficiency
FROM Staging_Data s
WHERE s.`Season Type` = 'Regular Season'
  AND s.PLAYER_ID IN (SELECT PlayerID FROM Player);
  
  INSERT INTO `Player Playoff Performance`
    (PlayerID, GP, W, L, MIN, FGM, FGA, FG_PCT, FG3M, FG3A, FG3_PCT,
    FTM, FTA, FT_PCT, OREB, DREB, REB, AST, TOV, STL, BLK, BLKA, PF, PFD,
    PTS, PLUS_MINUS, Efficiency)
SELECT
    s.PLAYER_ID, s.GP_x, s.W_x, s.L_x, s.MIN_x, s.FGM, s.FGA, s.FG_PCT,
    s.FG3M, s.FG3A, s.FG3_PCT, s.FTM, s.FTA, s.FT_PCT, s.OREB, s.DREB_x,
    s.REB, s.AST, s.TOV, s.STL_x, s.BLK_x, s.BLKA, s.PF, s.PFD,
    s.PTS, s.PLUS_MINUS, s.Efficiency
FROM Staging_Data s
WHERE s.`Season Type` = 'Playoffs'
  AND s.PLAYER_ID IN (SELECT PlayerID FROM Player);
  
  DROP TABLE Staging_Data;