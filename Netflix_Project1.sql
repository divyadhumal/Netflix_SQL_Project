--Netflix Project
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);

SELECT * FROM netflix;

SELECT COUNT(*) as total_content
FROM netflix;


SELECT 
	DISTINCT type
FROM netflix;

--15 Business Problems

--1. Count the number of Movies vs TV Shows
SELECT
	type,
	COUNT(*) as total_content
FROM netflix
GROUP BY type

--2.Find the most common rating for movies and TV shows

SELECT 
	type,
	rating
FROM
(	SELECT 
		type,
		rating,
		COUNT(*),
		RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
	FROM netflix
	GROUP BY 1,2
) as t1
WHERE 
	ranking =1
	
--3. List all movies released in a specific year(e.g..2020)
SELECT * FROM netflix
WHERE 
	type='Movie'
	AND
	release_year=2020

--4.Find the top 5 countries with the most content on netflix

SELECT 
	 UNNEST(STRING_TO_ARRAY(country,','))as new_country,
	 COUNT(show_id) as total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--5. Identify the longest Movie
SELECT *FROM netflix
WHERE 	
	type = 'Movie'
	AND
	duration = (SELECT MAX(duration) FROM netflix)
	
--6 find content added in the last 5 years

SELECT * FROM netflix
WHERE 
	 TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'

	 
SELECT CURRENT_DATE - INTERVAL '5 years'


--7.Find all the movies/TV shows by director 'Rajiv Chilaka'

SELECT * FROM  netflix
WHERE director ILIKE '%Rajiv Chilaka'

--8 List all TV shows with more than 5 seasons 
SELECT * FROM netflix
WHERE 
		type ='TV Show'
		AND
		SPLIT_PART(duration, ' ',1):: numeric >
		
 --9 Count the number of content items in each genre

SELECT 
		UNNEST(STRING_TO_ARRAY(listed_in,','))as genre,
		COUNT(show_id) as total_content
	FROM netflix
	GROUP BY 1
	
--10 Find each year and the average numbers of content release in INDIA on netflix .
--return top 5 year with highest avg content release

SELECT 
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
	COUNT(*) as yearly_content,
	ROUND(
	COUNT(*) :: numeric/(SELECT COUNT(*) FROM netflix WHERE country ='India'):: numeric * 100
	,2)as avg_content_per_year
FROM netflix
WHERE country ='India'
GROUP BY 1

FROM netflix
	WHERE country= 'India'

--11 List all movies that are documentaries
SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries';

--12. Find All Content Without a Director

SELECT * 
FROM netflix
WHERE director IS NULL;

--13.Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

--14.Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;

--15 Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;

