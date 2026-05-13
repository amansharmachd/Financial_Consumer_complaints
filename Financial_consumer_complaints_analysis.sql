CREATE DATABASE Financial_complaints;
USE Financial_complaints;

SELECT * FROM complaints_analysis;

#1 What is the total number of complaints received?
SELECT COUNT(*) AS Total_complaints from complaints_analysis;
 
 
 #2 What submission channel has the highest of complaints ?
 SELECT submitted_via,COUNT(complaint_id) as Total_complaints 
 FROM complaints_analysis 
 GROUP BY submitted_via 
 ORDER BY Total_complaints DESC;
 
 
 #3 Which top 10 state have the highest number of complaints ? 
SELECT state,COUNT(complaint_id) as Total_complaints
FROM complaints_analysis
GROUP BY state
ORDER BY Total_complaints DESC LIMIT 10;


#4 How many complaints were received for each Product Category ? 
SELECT product,COUNT(complaint_id) as Total_complaints
FROM complaints_analysis
GROUP BY product
ORDER BY Total_complaints DESC;


#5 What are the most common complaints issues ?
SELECT issue,COUNT(complaint_id) as Total_complaints
FROM complaints_analysis
GROUP BY issue
ORDER BY Total_complaints DESC;


#6 What is the timely response percentage for each submission Channel ?
SELECT submitted_via,COUNT(*) AS Total_complaints,
SUM(CASE
	WHEN timely_response = "Yes" THEN 1 ELSE 0
    END) * 100/ COUNT(*) AS Timely_response_rate
    FROM complaints_analysis
    GROUP BY submitted_via
    ORDER BY Timely_response_rate DESC;
    
    
#7 What is the monthly trend of complaints over time
SELECT 
	MONTH(date_submitted) AS Month_to_Month,
    COUNT(*) AS Total_complaints
    FROM complaints_analysis
    GROUP BY MONTH(date_submitted)
    ORDER BY Month_to_Month; 
    
    
#8 Which state has the highest complaints for each product category ?
SELECT state,product,Total_complaints
FROM 
	(SELECT 
		state,
        product,
        COUNT(*) AS Total_complaints,
        RANK() OVER (PARTITION BY product ORDER BY COUNT(*) DESC) AS rnk
	    FROM complaints_analysis
		GROUP BY state,product) ranked_data
        WHERE rnk = 1
		ORDER BY product; 
        
        
        
#9 Find the year-over-year growth percentage in complaints.
SELECT YEAR(date_submitted) AS Year_over_year,
COUNT(*) AS Total_complaints,
ROUND(
	(COUNT(*) - LAG(COUNT(*)) OVER (ORDER BY YEAR(date_submitted))) * 100/
    LAG(COUNT(*)) OVER (ORDER BY YEAR(date_submitted)),2) AS growth_percentage
FROM complaints_analysis
GROUP BY YEAR(date_submitted)
ORDER BY Year_over_year;


#10 Find the top complaint issue for each product category using ROW_NUMBER()

SELECT product,issue,Total_complaints
FROM 
	(SELECT 
        product,
        issue,
        COUNT(*) AS Total_complaints,
        ROW_NUMBER() OVER (PARTITION BY product ORDER BY COUNT(*) DESC) AS row_
	    FROM complaints_analysis
		GROUP BY product,issue) ranked_data
        WHERE row_ = 1
		ORDER BY product; 


 

    





