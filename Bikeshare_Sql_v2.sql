
USE [Bikeshare]
GO

SELECT [column1]
      ,[ride_id]
      ,[rideable_type]
      ,[started_at]
      ,[ended_at]
      ,[start_station_name]
      ,[end_station_name]
      ,[member_casual]
      ,[ride_length]
      ,[Weekday]
      ,[year]
      ,[month]
      ,[date]
      ,[start_time]
  FROM [dbo].[Bikeshare_22]

GO

ALTER TABLE [Bikeshare].dbo.Bikeshare_22
DROP COLUMN column1

ALTER TABLE [Bikeshare].dbo.Bikeshare_23
DROP COLUMN column1


-- Check for blank rows
SELECT COUNT(*) AS Ttl_Blanks FROM [Bikeshare].dbo.Bikeshare_22
WHERE ride_id IS NULL
  AND rideable_type IS NULL
  AND started_at IS NULL
  AND ended_at IS NULL
  AND member_casual IS NULL;

-- Check for blank rows
SELECT COUNT(*) AS Ttl_Blanks FROM [Bikeshare].dbo.Bikeshare_23
WHERE ride_id IS NULL
  AND rideable_type IS NULL
  AND started_at IS NULL
  AND ended_at IS NULL
  AND member_casual IS NULL;


--Check Tables
SELECT TOP(10) * FROM [Bikeshare].dbo.Bikeshare_22

SELECT COUNT(*) AS Totalrows FROM Bikeshare_22 -- Result 2,531,621

SELECT TOP(10) * FROM [Bikeshare].dbo.Bikeshare_23

SELECT COUNT(*) AS Totalrows FROM Bikeshare_23 -- Result 3,101,992



--Combine both year tables into Combined_table 
DROP TABLE IF EXISTS Combined_Bikeshare;


SELECT * INTO Combined_Bikeshare
FROM (
    SELECT * 
    FROM [Bikeshare].dbo.Bikeshare_22 AS A
    WHERE COALESCE(A.ride_id, '') <> ''

    UNION ALL

    SELECT * 
    FROM [Bikeshare].dbo.Bikeshare_23 AS B
    WHERE COALESCE(B.ride_id, '') <> ''
) AS AllRides;


-- Total number of rows (Correct Number of records 5,633,613)
SELECT COUNT(*) AS TotalRows FROM Combined_Bikeshare;


-- Check for Distinct values Results 5,631,598) **Discrempicy of 2015 records**
SELECT 
    COUNT(DISTINCT ride_id) AS DistinctRides,
    COUNT(DISTINCT rideable_type) AS DistinctBikeTypes,
	COUNT(DISTINCT started_at) AS Distinctstarted_at,
	COUNT(DISTINCT ended_at) AS Distinctended_at
FROM Combined_Bikeshare;


-- This CTE assigns row numbers to duplicates with same ride_id (moved 2015 duplicate rows into doubles_All)
WITH RankedDuplicates AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY ride_id ORDER BY started_at) AS rn
    FROM [Bikeshare].dbo.Combined_Bikeshare
)
-- Select rows that are duplicates (i.e., row number > 1)
SELECT *
INTO Doubles_All
FROM RankedDuplicates
WHERE rn > 1;

WITH RankedDuplicates AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY ride_id ORDER BY started_at) AS rn
    FROM [Bikeshare].dbo.Combined_Bikeshare
)
DELETE FROM RankedDuplicates
WHERE rn > 1;



-- Basic Summary Stats - Max, Min, and Mean ride duration
SELECT 
    MAX(DATEDIFF(MINUTE, started_at, ended_at)) AS MaxRideMinutes,
    MIN(DATEDIFF(MINUTE, started_at, ended_at)) AS MinRideMinutes,
    AVG(CAST(DATEDIFF(SECOND, started_at, ended_at) AS FLOAT)) / 60 AS AvgRideMinutes
FROM Combined_Bikeshare
WHERE started_at IS NOT NULL AND ended_at IS NOT NULL;

-- MaxRideMinutes	MinRideMinutes	AvgRideMinutes
-- 51462	1	18.655755258099

--Preferred Bike Types - Total riders per weekday per rider type

SELECT 
    DATENAME(WEEKDAY, started_at) AS Weekday,
    member_casual,
    COUNT(*) AS TotalRides
FROM Combined_Bikeshare
GROUP BY DATENAME(WEEKDAY, started_at), member_casual
ORDER BY Weekday;


-- Results:
Weekday	member_casual	TotalRides
Sunday	member	380099
Sunday	casual	327542
Thursday	casual	284846
Thursday	member	560192
Tuesday	casual	252983
Tuesday	member	542951
Wednesday	casual	258478
Wednesday	member	556845


-- Average ride length per weekday per rider type
SELECT 
    DATENAME(WEEKDAY, started_at) AS Weekday,
    member_casual,
    AVG(CAST(DATEDIFF(SECOND, started_at, ended_at) AS FLOAT)) / 60 AS AvgRideMinutes
FROM Combined_Bikeshare
WHERE started_at IS NOT NULL AND ended_at IS NOT NULL
GROUP BY DATENAME(WEEKDAY, started_at), member_casual
ORDER BY Weekday;

-- Results:
Weekday	member_casual	AvgRideMinutes
Friday	member	12.5675547416509
Friday	casual	27.8002332979852
Monday	casual	27.6633513003108
Monday	member	12.0283756247402
Saturday	member	14.1083298794522
Saturday	casual	33.0701117767916
Sunday	member	13.9139276872604
Sunday	casual	33.5364808177272
Thursday	casual	24.2099064055665
Thursday	member	12.0918613618188
Tuesday	casual	25.5256440156058
Tuesday	member	12.1032174174097
Wednesday	casual	24.4362228119995
Wednesday	member	11.9816879023786

-- Summary Stats - Create a table to store summary stats
SELECT 
    DATENAME(WEEKDAY, started_at) AS Weekday,
    member_casual,
    COUNT(*) AS TotalRides,
    AVG(CAST(DATEDIFF(SECOND, started_at, ended_at) AS FLOAT)) / 60 AS AvgRideMinutes
INTO Summary_RideStats
FROM Combined_Bikeshare
WHERE started_at IS NOT NULL AND ended_at IS NOT NULL
GROUP BY DATENAME(WEEKDAY, started_at), member_casual;


-- Exploring Interesting Trends (Example: Longest rides)

-- Top 10 longest rides
SELECT TOP 10 *
FROM Combined_Bikeshare
WHERE started_at IS NOT NULL AND ended_at IS NOT NULL
ORDER BY DATEDIFF(MINUTE, started_at, ended_at) DESC;

ride_id	rideable_type	started_at	ended_at	start_station_name	end_station_name	member_casual	ride_length	Weekday	year	month	date	start_time
CFB4246E9FAB59DA	docked_bike	2023-07-03 10:49:00.000	2023-08-08 04:31:00.000	Wabash Ave & Wacker Pl	NA	casual	51462	Monday	2023	7	3	06:49:00.0000000
15B627A79323EEA0	docked_bike	2023-07-01 13:38:00.000	2023-07-31 04:06:00.000	Millennium Park	NA	casual	42628	Saturday	2023	7	1	09:38:00.0000000
F354C5AABB811F6D	docked_bike	2023-07-07 14:38:00.000	2023-08-06 04:07:00.000	Field Museum	NA	casual	42569	Friday	2023	7	7	10:38:00.0000000
7D4CB0DD5137CA9A	docked_bike	2022-10-01 15:04:00.000	2022-10-30 08:51:00.000	St. Louis Ave & Fullerton Ave	NA	casual	41387	Saturday	2022	10	1	11:04:00.0000000
F802275985D8FF81	docked_bike	2023-07-05 09:31:00.000	2023-08-02 04:56:00.000	McCormick Place	NA	casual	40045	Wednesday	2023	7	5	05:31:00.0000000
115105E6D67C0136	docked_bike	2023-07-05 15:40:00.000	2023-07-31 04:52:00.000	Streeter Dr & Grand Ave	NA	casual	36792	Wednesday	2023	7	5	11:40:00.0000000
307CA01BAE3CC7E3	docked_bike	2023-01-08 11:08:00.000	2023-01-31 19:12:00.000	Michigan Ave & 8th St	NA	casual	33604	Sunday	2023	1	8	06:08:00.0000000
74CE9E086B3947AB	docked_bike	2023-07-01 20:48:00.000	2023-07-25 04:51:00.000	MLK Jr Dr & 47th St	NA	casual	33603	Saturday	2023	7	1	16:48:00.0000000
4BF7A8BC8417643F	docked_bike	2022-10-09 11:24:00.000	2022-10-31 04:33:00.000	Millennium Park	NA	casual	31269	Sunday	2022	10	9	07:24:00.0000000
B67CB84CE5C2DE82	docked_bike	2022-10-01 14:33:00.000	2022-10-23 04:47:00.000	Streeter Dr & Grand Ave	NA	casual	31094	Saturday	2022	10	1	10:33:00.0000000

-- Ride count by bike type
SELECT rideable_type, COUNT(*) AS RideCount
FROM Combined_Bikeshare
GROUP BY rideable_type
ORDER BY RideCount DESC;

rideable_type	RideCount
electric_bike	3042606
classic_bike	2460889
docked_bike  	128103