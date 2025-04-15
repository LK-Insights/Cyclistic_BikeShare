# Capstone Project: Cyclistic Bike Share Case Study 
By Lillian Kaiser - October 2023

## Case Background:

In this case study, the business task is to analyze historical bike trip data of Cyclistic, a bike-share company in Chicago, to understand how casual riders and Members use Cyclistic bikes differently. Cyclistic operates a successful bike-share business with 5,824 bicycles and 692 stations in Chicago. The company offers two Rider Types:

-	Casual Riders: These are customers who purchase single-ride or full-day passes, indicating they use the service infrequently or on a pay-as-you-go basis.<br>
-	Member: These are subscribers who pay for annual fee, providing them with unlimited access to the bikes throughout the year.<br>

The primary objective is to gain insights from the data that will help the marketing team develop a new strategy to convert casual riders into annual riders. To do this, the analysis will likely involve examining various aspects of bike usage by both types of customers, including ride frequency, trip duration, and popular riding days. The findings can be used to tailor marketing strategies that encourage casual riders to become members and thereby increase the company's recurring revenue.

### About the Company:

Cyclistic launched its bike-share program in 2016, which has since grown to include 5,824 GPS-tracked bikes across 692 stations in Chicago. Riders can pick up a bike from one station and return it to any other within the network, offering flexibility and convenience.

Cyclistic's marketing strategy has traditionally focused on raising awareness and attracting a broad customer base with flexible pricing options, including single-ride passes, full-day passes, and annual memberships. Casual riders purchase single-ride or full-day passes, while annual memberships offer more value and consistency.

Financial analysis shows that members are more profitable than casual riders. With future growth in mind, marketing lead Moreno believes the key is converting casual riders into annual riders. Casual riders are already familiar with Cyclistic and use it for their mobility needs, making them a prime target for membership.

Moreno’s goal is to develop marketing strategies focused on this conversion. To support this, the marketing team is working to understand the differences between casual riders and Annual riders, explore what would motivate casual riders to switch, and assess how digital media can enhance these efforts. They’ll be analyzing historical bike trip data to uncover trends that can guide their approach.

### Google Data Analysis Process:

The Google Data Analytics Professional Certificate uses a methodology for data analysis which involves 6 phrases:  ASK, PREPARE, PROCESS, ANALYSE, SHARE AND ACT

## Ask – Understanding the project and problem that needs solving <br>
Business Task: Define the Problem:
The challenge at hand is to create a data-driven marketing campaign that will effectively convert casual riders of Cyclistic, a bike-share company in Chicago, into annual riders. The future success of Cyclistic heavily relies on maximizing the number of annual riderships. The director of marketing, Lily Moreno, envisions a comprehensive strategy that not only attracts new customers but also capitalizes on the existing awareness of the Cyclistic program among casual riders.
The business goal is to understand the behavioral differences between casual riders and annual riders, in order to develop data-driven strategies that encourage casual riders to become annual riders.

#### Stakeholders:
-	**Lily Moreno:** Director of Marketing <BR>
-	**Cyclistic executive team:** The notoriously detail-oriented executive team will decide whether to approve the recommended marketing program.<BR>
-	**Cyclistic Marketing Analytics Team:** who are responsible for collecting, analyzing, and reporting data that helps guide Cyclistic marketing strategy. <BR>

#### Deliverables for the project:
  1. A clear statement of the business task
  2.	A description of all data sources used
  3.	Documentation of any cleaning or manipulation of data
  4.	A summary of the analysis
  5.	Supporting visualizations and key findings
  6. Top three recommendations based on the analysis

#### Three questions that will guide the marketing project:
  1.	How do annual riders and casual riders use Cyclistic bikes differently?
  2.	Why would casual riders buy Cyclistic memberships? 
  3.	How can Cyclistic use digital media to influence casual riders to become annual riders?

<br>

## Prepare – Extract and prepare the data for analysis <br>

### Data Acquisition and Verification:
-	Data Source: Obtain Cyclistic historical bike trip data from the official source: Cyclistic Historical Data. <br>
-	Data License: Ensure data availability under the license agreement provided by Motivate International Inc.: Data License Agreement.<br>
-	Public Accessibility: Verify that the data is publicly accessible.

### Data Integrity Verification:
•	Data Duration: Utilize a 12-month dataset spanning from August 2022 to July 2023 to identify trends.<br>
•	ROCCC Analysis:<pre> 
   •	Reliable: Confirm that the dataset is unbiased and reliable.
   •	Original: Ensure that the dataset used in the analysis is original and publicly accessible.
   •	Comprehensive: Check that the dataset is comprehensive and free from significant missing or incomplete information.
   •	Current: Verify that the data is up to date and updated on a monthly basis.
   •	Citation: Confirm that the dataset is appropriately cited.</pre>
   
### Data Extraction and Organization:

  - Data Download: Download 12 CSV files, each covering a specific month from August 2022 to July 2023. Store these files on your computer for analysis.<BR>
  - Data Variables: Identify that each CSV file contains the same 9 variables, including Distinct Ride ID, bike types, station information (ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, membership ride_length, Weekday)  <BR>
  -	Data Organization: Organize the data by grouping it by month and year to facilitate analysis.<BR>
  -	Data Filtering and Sorting: Filter and sort the data to identify patterns and relationships related to ride frequency and ride duration, which are essential for understanding membership adoption.<BR>

### Insight Identification:
  -	Consider explaining common factors among members, such as ride frequency and ride duration, to better understand how these behaviors relate to membership adoption.<BR>
  - Plan to present insights that suggest correlations between usage patterns and annual ridership purchases.<BR>
This organized process will ensure that the data is ready for in-depth analysis and deriving valuable insights for Cyclistic's business needs.<BR>
<br>

## Process - Deliverable Documentation of any cleaning or manipulation of data <br>

During the data preparation phase, I utilized Microsoft Excel 2016 for initial cleaning and manipulation. Given the dataset's size — over 5 million entries — I transitioned to RStudio for more efficient processing.

The data, sourced from Cyclistic’s internal records, is maintained with a high level of credibility. However, like any dataset, it may contain inherent limitations or biases, as it primarily reflects user interactions within the Cyclistic bike-sharing system.

To uphold data integrity, I took the following measures:
-	Gained a thorough understanding of the data’s origin and potential limitations.
-	Maintained backups of the original files.
-	Tracked all changes to ensure a clear audit trail throughout the cleaning process.

### Data Issues Addressed:
-	Performed a duplicate check using all columns, then deleted duplicates.
-	Removed rows with invalid ride_id values (e.g., ##################), as these were duplicates of entries with valid IDs.
-	Detected corrupted ride_ids (e.g., 1.11+14) likely caused by data type or encoding issues during import. These were corrected when possible or removed if unverifiable.
-	Calculated ride duration by subtracting started_at from ended_at, then removed entries with negative or zero durations.
-	Excluded rides lasting less than one minute, as these likely did not represent meaningful usage behavior. This decision was made to ensure focus on typical ride patterns relevant to our business questions.

This careful preparation ensured an accurate and reliable dataset for analysis. It was essential to answering our three focus questions:

1.	How do annual riders and casual riders use Cyclistic bikes differently?
2.	Why might casual riders purchase Cyclistic annual riderships?
3.	How can Cyclistic use digital media to influence casual riders to become annual riders?

This rigorous data preparation process was essential in ensuring the dataset’s accuracy, consistency, and alignment with our business goals. It enabled us to perform a meaningful analysis of usage patterns between annual riders and casual riders, explore potential motivations for purchasing annual riderships, and develop recommendations for digital media strategies to increase conversions.

### Excel:
1.	Added ride_length formula: consisting of the time difference between Start_at and ended_at 
2.	Deleted all records under 1 minute (see explanation in appendix).
3.	Check for Duplications: No Duplications
4.	Remove unnecessary columns to reduce file size: start_lat, start_lng, end_lat, end_lng, started_stationID, and ended_StationID <br>
 

## Analyze - A summary of your analysis
Analyze Phase: Unveiling Cyclistic's Rider Behavior Patterns
Understanding how different user groups engage with Cyclistic's bike-sharing services is crucial for tailoring offerings and marketing strategies. This analysis delves into the riding patterns of members versus casual riders, examining ride durations, preferences, and temporal trends to identify opportunities for enhancing user experience and increasing membership conversions.
Let’s start with an overall look at the Length of rides by each rider type (Member vs. Casual riders)

Ride Duration Insights
-	Overall Ride Lengths: The average ride duration across all users is 18 minutes.
-	By Membership Type:
  -	Members: Average ride duration is 12.6 minutes.
  -	Casual Riders: Average ride duration is 28.6 minutes.
This information indicates that casual riders tend to take longer trips compared to members.

https://github.com/LK-Insights/Cyclistic_BikeShare/tree/main/Average_Ride_Length.png
