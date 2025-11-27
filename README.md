# NBA Database (nba-db)

## Overview

This project is a relational database system containing player and team performance data for the NBA 2023-24 season. The database provides detailed analysis opportunities by separating both playoff and regular season statistics on a home and away basis.

## Database Schema

### Main Tables

#### 1. TEAMS
Contains information for 30 NBA teams.

**Columns:**
- `teamID` (INT, PRIMARY KEY): Team unique identifier
- `teamName` (VARCHAR(100)): Team full name
- `teamAbbreviation` (VARCHAR(10)): Team abbreviation (e.g., MIL, LAL)
- `logoUrl` (VARCHAR(255)): Team logo URL address
- `conference` (VARCHAR(20)): Conference information (East/West)

**Sample Data:**
- Milwaukee Bucks (East Conference)
- Los Angeles Lakers (West Conference)
- Dallas Mavericks (West Conference)

#### 2. PLAYERS
Contains basic information for NBA players. Dependent on the TEAMS table.

**Columns:**
- `playerID` (INT, PRIMARY KEY): Player unique identifier
- `playerName` (VARCHAR(100)): Player name
- `teamID` (INT, FOREIGN KEY): Player's team identifier
- `position` (VARCHAR(20)): Player position (Guard, Forward, Center, etc.)
- `headshotUrl` (VARCHAR(255)): Player photo URL address

**Relationships:**
- Foreign Key: `teamID` → TEAMS(teamID)

#### 3. PlayerRegularSeasonPerformance
Contains detailed performance statistics for players in regular season games.

**Columns:**
- `playerID` (INT): Player identifier
- `teamID` (INT): Team identifier
- `teamName` (VARCHAR(100)): Team name
- `location` (ENUM('HOME','AWAY')): Game location
- `GP_X` (INT): Games played
- `MIN_X` (FLOAT): Average playing time (minutes)
- **Shooting Statistics:**
  - `FGM` (FLOAT): Field Goals Made
  - `FGA` (FLOAT): Field Goals Attempted
  - `FG_PCT` (FLOAT): Field Goal Percentage
  - `FG3M` (FLOAT): 3-Point Field Goals Made
  - `FG3A` (FLOAT): 3-Point Field Goals Attempted
  - `FG3_PCT` (FLOAT): 3-Point Percentage
  - `FTM` (FLOAT): Free Throws Made
  - `FTA` (FLOAT): Free Throws Attempted
  - `FT_PCT` (FLOAT): Free Throw Percentage
- **Rebound Statistics:**
  - `offensiveREB` (FLOAT): Offensive rebounds
  - `defensiveREB` (FLOAT): Defensive rebounds
  - `REB` (FLOAT): Total rebounds
- **Other Statistics:**
  - `AST` (FLOAT): Assists
  - `TOV` (FLOAT): Turnovers
  - `steal` (FLOAT): Steals
  - `PF` (FLOAT): Personal fouls
  - `PTS` (FLOAT): Points
  - `PLUS_MINUS` (FLOAT): Plus/Minus statistic
  - `efficiency` (FLOAT): Efficiency score

**Primary Key:** (`playerID`, `teamID`, `location`)

**Relationships:**
- Foreign Key: `playerID` → PLAYERS(playerID)
- Foreign Key: `teamID` → TEAMS(teamID)

#### 4. PlayerPlayoffsPerformance
Contains detailed performance statistics for players in playoff games. Columns are the same as `PlayerRegularSeasonPerformance`.

**Features:**
- Same structure as regular season
- Contains data specific to playoff games
- Home/Away distinction is made

#### 5. TeamRegularSeasonPerformance
Contains general performance rankings for teams in the regular season.

**Columns:**
- `teamID` (INT, PRIMARY KEY): Team identifier
- `winRank` (INT): Win ranking
- `defRatingRank` (INT): Defensive rating ranking
- `defRebRank` (INT): Defensive rebound ranking
- `stealRank` (INT): Steal ranking
- `blockRank` (INT): Block ranking

**Relationships:**
- Foreign Key: `teamID` → TEAMS(teamID)

#### 6. TeamPlayoffsPerformance
Contains general performance rankings for teams in the playoffs. Columns are the same as `TeamRegularSeasonPerformance`.

## Data Sources

The database is created from the following CSV files:

### CSV Files (csvs/cleaned/)
- **playoff_clean.csv**: Playoff player performance data (616 rows)
- **regular_season_temiss_clean.csv**: Regular season player performance data (1564 rows)
- **playoff_court_clean.csv**: Playoff court-based data
- **regular_season_court_clean.csv**: Regular season court-based data
- **overalls/playoff_overall_clean.csv**: Playoff overall statistics
- **overalls/regular_season_overall_clean.csv**: Regular season overall statistics

## Database Features

### Character Set
- UTF-8 (utf8mb4) character set is used
- Support for Turkish characters and emojis

### Relational Structure
```
TEAMS (Parent)
  ├── PLAYERS (Child of TEAMS)
  │     ├── PlayerRegularSeasonPerformance
  │     └── PlayerPlayoffsPerformance
  ├── TeamRegularSeasonPerformance
  └── TeamPlayoffsPerformance
```

### Key Features
- **Location-Based Statistics**: HOME and AWAY performance data are kept separately
- **Comprehensive Performance Metrics**: 20+ different performance metrics
- **Hierarchical Structure**: Teams → Players → Performance data
- **Referential Integrity**: Data integrity with foreign key constraints

## Installation and Usage

### 1. Creating the Database
```bash
mysql -u [username] -p < init.sql
```

### 2. Connecting to the Database
```bash
mysql -u [username] -p nba_db
```

### 3. Example Queries

#### Player Statistics
```sql
-- LeBron James's regular season home performance
SELECT * FROM PlayerRegularSeasonPerformance 
WHERE playerID = 2544 AND location = 'HOME';

-- Top scorers (home games)
SELECT p.playerName, prs.PTS, prs.teamName
FROM PLAYERS p
JOIN PlayerRegularSeasonPerformance prs ON p.playerID = prs.playerID
WHERE prs.location = 'HOME'
ORDER BY prs.PTS DESC
LIMIT 10;
```

#### Team Comparisons
```sql
-- East Conference teams' playoff performance
SELECT t.teamName, tpp.winRank, tpp.defRatingRank
FROM TEAMS t
JOIN TeamPlayoffsPerformance tpp ON t.teamID = tpp.teamID
WHERE t.conference = 'East'
ORDER BY tpp.winRank;
```

#### Home vs Away Analysis
```sql
-- Players' home and away performance difference
SELECT 
    p.playerName,
    home.PTS as home_pts,
    away.PTS as away_pts,
    (home.PTS - away.PTS) as pts_difference
FROM PLAYERS p
JOIN PlayerRegularSeasonPerformance home ON p.playerID = home.playerID AND home.location = 'HOME'
JOIN PlayerRegularSeasonPerformance away ON p.playerID = away.playerID AND away.location = 'AWAY'
WHERE home.teamID = away.teamID;
```

## Data Statistics

- **Total Teams**: 30 NBA teams
- **Total Players**: 500+ active players
- **Regular Season Data**: 1564 records (with HOME/AWAY distinction)
- **Playoff Data**: 616 records (with HOME/AWAY distinction)
- **Season**: 2023-24

## Technical Details

### Database Engine
- InnoDB (Transaction support, Foreign keys)

### Data Types
- INT: IDs and numerical data
- FLOAT: Statistical data (averages, percentages)
- VARCHAR: Text data (names, URLs)
- ENUM: Fixed values (HOME/AWAY)

### Indexes
- Primary Keys: Automatic indexing
- Foreign Keys: Optimized for relational queries

## Insert Scripts

Ready-to-use Python scripts for adding data to the database:

### insert_folder/
- `players_inserts.py`: Inserts player data
- `team_table_inserts.py`: Inserts team data
- `player_rl_inserts.py`: Inserts regular season player statistics
- `player_poff_inserts.py`: Inserts playoff player statistics
- `team_rl_inserts.py`: Inserts regular season team statistics
- `team_poff_inserts.py`: Inserts playoff team statistics

## License and Usage

This database contains NBA 2023-24 season data. Designed for educational purposes.

## Contributors

BLG317E Database Systems - Term Project

---

**Last Updated**: November 2025  
**Database Version**: 1.0  
**MySQL Version**: 8.0+
NBA Database Project
This project takes flat-file NBA player and team statistics from final_data.csv and transforms them into a normalized, relational MySQL database.

The database schema (ERD) separates the original CSV data into 7 primary tables:

Conference

Team

Player

TeamStats

OpponentStats

Player Regular Season Performance (Performance data is split by 'Season Type')

Player Playoff Performance (Performance data is split by 'Season Type')

How to Use
This project uses a 3-step ETL (Extract, Transform, Load) process.

Step 1: Create the Schema
Run the 01_schema.sql script in your MySQL database.

Bash

mysql -u [your_user] -p [your_database_name] < 01_schema.sql
This command creates the 7 primary normalized tables and one Staging_Data table to temporarily hold the raw data.

Step 2: Load the Raw Data (Manual Step)
These scripts do not read the CSV file. You must manually import final_data.csv into the Staging_Data table.

Using a GUI (e.g., MySQL Workbench):

In the nba_veritabani schema, right-click on the staging_data table under Tables.

Select "Table Data Import Wizard".

Browse and select final_data.csv as the source file.

Ensure the target is the staging_data table.

Crucially, ensure "First line contains column names" is checked, and run the import.

Using the Command Line (LOAD DATA INFILE):

(This is the preferred method for server deployments. You may need to check your secure_file_priv settings.)

SQL

LOAD DATA INFILE '/path/to/your/final_data.csv'
INTO TABLE Staging_Data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
Step 3: Populate and Clean
Once the Staging_Data table is full, run the 02_populate_data.sql script.

Bash

mysql -u [your_user] -p [your_database_name] < 02_populate_data.sql
This script will:

Read the raw data from Staging_Data.

Clean the "dirty" data (Duplicate key errors via GROUP BY, Foreign key errors via WHERE IN).

Distribute the clean, normalized data into the 7 primary tables.

Drop the Staging_Data table after completion.
