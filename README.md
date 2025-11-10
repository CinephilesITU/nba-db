# nba-db
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
