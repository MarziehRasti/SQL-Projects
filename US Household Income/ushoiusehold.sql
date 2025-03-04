SELECT COUNT(id) 
FROM USHousehold.ushousehold_statistics
;

SELECT COUNT(id) 
FROM USHousehold.USHouseholdIncome
;

SELECT *
FROM USHousehold.USHouseholdIncome
;

#1 looking for duplicate in USHouseholdIncome table

SELECT id,COUNT(id)
FROM USHousehold.USHouseholdIncome
GROUP BY id
HAVING COUNT(id)>1
;


#delete duplicate rows, first select the duplicate rows

SELECT *
FROM (
	SELECT id,
row_id,
ROW_NUMBER() OVER(PARTITION BY id ORDER BY id)AS row_num
FROM USHousehold.USHouseholdIncome) As duplicates
WHERE row_num >1;

#2 now we can delete selected duplicate rows

DELETE FROM USHouseholdIncome
WHERE row_id IN (
	SELECT row_id
	FROM (
		SELECT id,
		row_id,
		ROW_NUMBER() OVER(PARTITION BY id ORDER BY id)AS row_num
		FROM USHousehold.USHouseholdIncome) As duplicates
	WHERE row_num >1);
    
    
    #3 looking for duplicate in usHousehold_statistics table

SELECT id,COUNT(id)
FROM USHousehold.ushousehold_statistics
GROUP BY id
HAVING COUNT(id)>1
;
 ## we don't have duplicate in this table
 
SELECT *
FROM USHousehold.USHouseholdIncome
;

#looking for typo in state name

SELECT State_Name, COUNT(State_Name)
FROM USHousehold.USHouseholdIncome
GROUP BY State_Name
;   
    
    
SELECT DISTINCT(State_Name)
FROM USHousehold.USHouseholdIncome
;   

SET SQL_SAFE_UPDATES = 0;


UPDATE USHousehold.USHouseholdIncome
SET State_Name ='Georgia'
WHERE State_Name= 'georia'
;

UPDATE USHousehold.USHouseholdIncome
SET State_Name ='Alabama'
WHERE State_Name= 'alabama'
;

SELECT DISTINCT(State_ab)
FROM USHousehold.USHouseholdIncome
; 


SELECT * 
FROM USHousehold.USHouseholdIncome
WHERE Place IS NULL OR Place = '' 
ORDER BY 1;


SELECT * 
FROM USHousehold.USHouseholdIncome
WHERE County= 'Autauga County'
;

# we ca find different type and typo
SELECT Type, COUNT(Type)
FROM USHousehold.USHouseholdIncome
GROUP BY Type
;


UPDATE USHouseholdIncome
SET Type= 'Borough'
WHERE Type='Boroughs'
;

UPDATE USHouseholdIncome
SET Type= 'CDP'
WHERE Type='CPD'
;

SELECT ALand,AWater
FROM USHousehold.USHouseholdIncome
WHERE (AWater =0 OR AWater ='' OR AWater IS NULL)
;

SELECT ALand,AWater
FROM USHousehold.USHouseholdIncome
WHERE (AWater =0 OR AWater ='' OR AWater IS NULL)
AND (ALand =0 OR ALand ='' OR ALand IS NULL)
;

SELECT ALand,AWater
FROM USHousehold.USHouseholdIncome
WHERE ALand =0 OR ALand ='' OR ALand IS NULL
;


# Exploratory Data Analysis

SELECT State_Name, SUM(ALand),SUM(AWater)
FROM USHousehold.USHouseholdIncome
GROUP BY State_Name
ORDER BY 2 DESC
LIMIT 10
;

SELECT * 
FROM USHousehold.USHouseholdIncome
;

SELECT * 
FROM USHousehold.ushousehold_statistics
;

SELECT * 
FROM USHousehold.USHouseholdIncome u
INNER JOIN  USHousehold.ushousehold_statistics us
	ON u.id=us.id
WHERE Mean <>0
;


SELECT u.State_Name,County,Type,`Primary`,Mean,Median 
FROM USHousehold.USHouseholdIncome u
INNER JOIN  USHousehold.ushousehold_statistics us
	ON u.id=us.id
WHERE Mean <>0
;

SELECT u.State_Name,ROUND(AVG(Mean),1),ROUND(AVG(Median),1)
FROM USHousehold.USHouseholdIncome u
INNER JOIN  USHousehold.ushousehold_statistics us
	ON u.id=us.id
WHERE Mean <>0
GROUP BY u.State_Name
ORDER BY 2 ASC
LIMIT 10
;

SELECT Type, COUNT(Type),ROUND(AVG(Mean),1),ROUND(AVG(Median),1)
FROM USHousehold.USHouseholdIncome u
INNER JOIN  USHousehold.ushousehold_statistics us
	ON u.id=us.id
WHERE Mean <>0
GROUP BY Type
ORDER BY 3 ASC
LIMIT 20
;


# to filter data with very low number taht looks like a outlier, we can filetr them by using HAVING

SELECT Type, COUNT(Type),ROUND(AVG(Mean),1),ROUND(AVG(Median),1)
FROM USHousehold.USHouseholdIncome u
INNER JOIN  USHousehold.ushousehold_statistics us
	ON u.id=us.id
WHERE Mean <>0
GROUP BY Type
HAVING COUNT(Type)>100
ORDER BY 3 ASC
LIMIT 20
;


SELECT u.State_Name,City,ROUND(AVG(Mean),1),ROUND(AVG(Median),1)
FROM USHousehold.USHouseholdIncome u
INNER JOIN  USHousehold.ushousehold_statistics us
	ON u.id=us.id
GROUP BY u.State_Name,City
ORDER BY ROUND(AVG(Mean),1) DESC
;















