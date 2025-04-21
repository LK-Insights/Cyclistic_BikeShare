
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
) AS Combined_Bikeshare;


-- Total number of rows (Correct Number of records 5,633,613)
SELECT COUNT(*) AS TotalRows FROM Combined_Bikeshare;


-- Check for Distinct values Results 5,633,613) 
SELECT COUNT(*) AS TotalRows,
       COUNT(DISTINCT CONCAT(
           ride_id, '|', 
           rideable_type, '|', 
           started_at, '|', 
           ended_at, '|', 
           start_station_name, '|', 
           end_station_name, '|', 
           member_casual
       )) AS UniqueRowCount
FROM Combined_Bikeshare;


---- This CTE assigns row numbers to duplicates with same ride_id (moved duplicate rows into doubles_All)
--WITH RankedDuplicates AS (
--    SELECT *,
--           ROW_NUMBER() OVER (PARTITION BY ride_id ORDER BY started_at) AS rn
--    FROM [Bikeshare].dbo.Combined_Bikeshare
--)
---- Select rows that are duplicates (i.e., row number > 1)
--SELECT *
--INTO Doubles_All
--FROM RankedDuplicates
--WHERE rn > 1;

--WITH RankedDuplicates AS (
--    SELECT *,
--           ROW_NUMBER() OVER (PARTITION BY ride_id ORDER BY started_at) AS rn
--    FROM [Bikeshare].dbo.Combined_Bikeshare
--)
--DELETE FROM RankedDuplicates
--WHERE rn > 1;



-- Basic Summary Stats - Max, Min, and Mean ride duration
SELECT 
    MAX(DATEDIFF(MINUTE, started_at, ended_at)) AS MaxRideMinutes,
    MIN(DATEDIFF(MINUTE, started_at, ended_at)) AS MinRideMinutes,
    AVG(CAST(DATEDIFF(SECOND, started_at, ended_at) AS Numeric)) / 60 AS AvgRideMinutes
FROM Combined_Bikeshare
WHERE started_at IS NOT NULL AND ended_at IS NOT NULL;

-- MaxRideMinutes	MinRideMinutes	AvgRideMinutes
-- 51462			1				18.654888


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


--Preferred Bike Types - Total riders per weekday per rider type

SELECT 
    DATENAME(WEEKDAY, started_at) AS Weekday,
    member_casual,
    COUNT(*) AS TotalRides
FROM Combined_Bikeshare
GROUP BY DATENAME(WEEKDAY, started_at), member_casual
ORDER BY Weekday;

--Results:
--Weekday	member_casual	TotalRides
--Friday	member			508000
--Friday	casual			330170
--Monday	casual			254248
--Monday	member			493376
--Saturday	member			453759
--Saturday	casual			428962
--Sunday	member			380236
--Sunday	casual			327670
--Thursday	casual			284938
--Thursday	member			560413
--Tuesday	casual			253097
--Tuesday	member			543135
--Wednesday	casual			258554
--Wednesday	member			557055



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
----Weekday	member_casual	AvgRideMinutes
----Friday	member	12.5672952755906
----Friday	casual	27.7970166883727
----Monday	casual	27.6640288222523
----Monday	member	12.0279502853807
----Saturday	member	14.1079780235764
----Saturday	casual	33.0682974249467
----Sunday	member	13.9134406000484
----Sunday	casual	33.5355632190924
----Thursday	casual	24.2064940443184
----Thursday	member	12.0919910851461
----Tuesday	casual	25.5220330545206
----Tuesday	member	12.1029430988612
----Wednesday	casual	24.4337159742259
----Wednesday	member	11.982007162668



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
electric_bike	3043666
classic_bike	2461795
docked_bike		128152

