# World_Life_Expectancy(Data Cleaning)


SELECT * 
FROM worldlifexpectancy
;

SELECT Country,Year,CONCAT(Country,Year),COUNT(CONCAT(Country,Year))
FROM worldlifexpectancy
GROUP BY Country,Year,CONCAT(Country,Year)
HAVING COUNT(CONCAT(Country,Year)) >1
;


SELECT *
FROM(
	SELECT Row_ID,
	CONCAT(Country,Year),
	ROW_NUMBER() OVER(PARTITION BY CONCAT(Country,Year)ORDER BY CONCAT(Country,Year)) as Row_Num
	FROM worldlifexpectancy) as Row_table
WHERE Row_Num >1
;

DELETE FROM worldlifexpectancy
WHERE 
	Row_ID IN(
	SELECT Row_ID
FROM(
	SELECT Row_ID,
	CONCAT(Country,Year),
	ROW_NUMBER() OVER(PARTITION BY CONCAT(Country,Year)ORDER BY CONCAT(Country,Year)) as Row_Num
	FROM worldlifexpectancy) as Row_table
WHERE Row_Num >1)
;

SET SQL_SAFE_UPDATES=0;


SELECT *
FROM worldlifexpectancy
WHERE status='';


SELECT DISTINCT(status)
FROM worldlifexpectancy
WHERE status <>'';


SELECT DISTINCT(Country)
FROM worldlifexpectancy
WHERE status = 'Developing'
;


UPDATE worldlifexpectancy t1
JOIN worldlifexpectancy t2
	ON t1.Country= t2.Country
SET t1.Status= 'Developing'
WHERE t1.Status = ''
AND t2.Status <>''
AND t2.Status= 'Developing'
;



UPDATE worldlifexpectancy t1
JOIN worldlifexpectancy t2
	ON t1.Country= t2.Country
SET t1.Status= 'Developed'
WHERE t1.Status = ''
AND t2.Status <>''
AND t2.Status= 'Developed'
;


SELECT *
FROM worldlifexpectancy
WHERE Lifeexpectancy= ''
;

## We want to use average Lifeexpectancy from one eyear before and one year after to populate empty Lifeexpectancy rows

SELECT t1.Country,t1.Year,t1.Lifeexpectancy,
t2.Country,t2.Year,t2.Lifeexpectancy,
t3.Country,t3.Year,t3.Lifeexpectancy,
ROUND((t2.Lifeexpectancy + t3.Lifeexpectancy)/2,1)
FROM worldlifexpectancy t1
JOIN worldlifexpectancy t2
	ON t1.Country=t2.Country
    AND t1.Year=t2.Year-1
JOIN worldlifexpectancy t3
	ON t2.Country=t3.Country
    AND t1.Year= t3.Year+1
WHERE t1.Lifeexpectancy= ''
;


UPDATE worldlifexpectancy t1
JOIN worldlifexpectancy t2
	ON t1.Country=t2.Country
    AND t1.Year=t2.Year-1
JOIN worldlifexpectancy t3
	ON t2.Country=t3.Country
    AND t1.Year= t3.Year+1
SET t1.Lifeexpectancy = ROUND((t2.Lifeexpectancy + t3.Lifeexpectancy)/2,1)
WHERE t1.Lifeexpectancy=''
;

SELECT *
FROM worldlifexpectancy
;


SELECT Country,MIN(Lifeexpectancy),
MAX(Lifeexpectancy),
ROUND(MAX(Lifeexpectancy) - MIN(Lifeexpectancy),1) AS Life_increase_15_years
FROM worldlifexpectancy
GROUP BY Country
HAVING MIN(Lifeexpectancy) <>0
AND MAX(Lifeexpectancy)<>0
ORDER BY Life_increase_15_years DESC
;



SELECT Year, ROUND(AVG(Lifeexpectancy),2)
FROM worldlifexpectancy
WHERE Lifeexpectancy<>0
GROUP BY Year
ORDER BY Year 
;

# looking for any correlation

SELECT Country,ROUND(AVG(Lifeexpectancy),2)AS Life_Expectancy, ROUND(AVG(GDP),1)AS GDP
FROM worldlifexpectancy
GROUP BY Country
HAVING Life_Expectancy >0
AND GDP >0
ORDER BY GDP ASC
;

SELECT Country,ROUND(AVG(Lifeexpectancy),2)AS Life_Expectancy, ROUND(AVG(GDP),1)AS GDP
FROM worldlifexpectancy
GROUP BY Country
HAVING Life_Expectancy >0
AND GDP >0
ORDER BY GDP ASC
;


SELECT 
CASE
	WHEN GDP >=1500
    THEN 1
    ELSE 0
END high_gdp_count
FROM worldlifexpectancy
;



SELECT 
SUM(CASE WHEN GDP >=1500 THEN 1 ELSE 0 END )high_gdp_count,
AVG(CASE WHEN GDP >=1500 THEN Lifeexpectancy ELSE NULL END )high_gdp_Life_Expectancy,
SUM(CASE WHEN GDP <=1500 THEN 1 ELSE 0 END )low_gdp_count,
AVG(CASE WHEN GDP <=1500 THEN Lifeexpectancy ELSE NULL END )low_gdp_Life_Expectancy
FROM worldlifexpectancy
;

SELECT Status,AVG(Lifeexpectancy)
FROM worldlifexpectancy
GROUP BY Status
;

SELECT Status,COUNT(DISTINCT(Country))
FROM worldlifexpectancy
GROUP BY Status
;


SELECT Status,COUNT(DISTINCT(Country)),ROUND(AVG(Lifeexpectancy),1)
FROM worldlifexpectancy
GROUP BY Status
;


SELECT Country,ROUND(AVG(Lifeexpectancy),2)AS Life_Expectancy, ROUND(AVG(BMI),1)AS BMI
FROM worldlifexpectancy
GROUP BY Country
HAVING Life_Expectancy >0
AND BMI >0
ORDER BY BMI DESC
;

SELECT Country,
Year,
Lifeexpectancy,
AdultMortality,
SUM(AdultMortality) OVER(PARTITION By Country ORDER BY Year) AS rolling_total
FROM worldlifexpectancy
;




