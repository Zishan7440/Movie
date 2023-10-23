/****** Script for SelectTopNRows command from SSMS  ******/
/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [name]
      ,[rating]
      ,[genre]
      ,[year]
      ,[released]
      ,[score]
      ,[votes]
      ,[director]
      ,[writer]
      ,[star]
      ,[country]
      ,[budget]
      ,[gross]
      ,[company]
      ,[runtime]
  FROM [Movie].[dbo].[movies$]

  select * from movies$;

 select* from movies$ where * IS NOT NULL;

 [To slplit date and string]
SELECT*,
    SUBSTRING(released, 1, CHARINDEX('(', released) - 2) AS ReleasedDate,
    SUBSTRING(released, CHARINDEX('(', released) + 1, LEN(released) - CHARINDEX('(', released) - 1) AS StringPart
FROM movies$;

1. Which Movie has the highest and lowest revenue?

Highest Revenue

select name, gross as max_gross
from movies$
group by name, gross
Having gross = (SELECT MAX(gross) FROM movies$);

Lowest Revenue

1. Which Movie has the highest and lowest revenue?

SELECT name,
       FIRST_VALUE(gross) OVER (ORDER BY gross ASC) AS Lowest_rnk,
       FIRST_VALUE(gross) OVER (ORDER BY gross DESC) AS Highest_rnk
FROM movies$
where gross IS NOT NULL
order by 1;

2. How does the revenue of different genres compare?

with t1 as
(select Genre, AVG(gross) as avg_revenue
from movies$
group by genre)
select *, RANK() OVER(ORDER BY avg_revenue DESC) as Rnk
from t1
order by Rnk;

3. How has the average movie budget changed over the years?

select YEAR, AVG(budget) as Avg_Budget
from movies$
group by year
order by year;

4. Which countries produce the most movies in the dataset?

select country, COUNT(name) as movie_count
from movies$
group by country
order by movie_count desc;

5. What are the most common movie genres?

select genre, COUNT(1) as count_of_genre,
ROUND(COUNT(1) * 100.0 / (SELECT COUNT(*) FROM movies$), 2) AS genre_percentage
from movies$
group by genre
order by count_of_genre desc;

6. What is the distribution of movie budgets in the dataset?

With t1 as
(SELECT
    CASE
        WHEN budget >= 0 AND budget < 1000000 THEN 'Less than 1 million'
        WHEN budget >= 1000000 AND budget < 10000000 THEN '1 million - 10 million'
        WHEN budget >= 10000000 AND budget < 50000000 THEN '10 million - 50 million'
        WHEN budget >= 50000000 AND budget < 100000000 THEN '50 million - 100 million'
        WHEN budget >= 100000000 THEN 'More than 100 million'
        ELSE 'Unknown'
    END AS budget_range
	FROM movies$)
select budget_range, count(*) as Count_movies
from t1
group by budget_range
order by Count_movies desc;

7. What is the distribution of IMDb user ratings (scores) in the dataset?

With t1 as 
(Select Case when score >= 1 AND score <= 5 THEN ' 1 - 5 '
			 when score >= 6 AND score <= 8 THEN ' 6 - 8 '
			 When score >= 9 AND score <= 10 THEN ' 9 - 10 '
			 Else 'Unknown'
			 END AS IMDB_Rating 
			 From movies$)
Select IMDB_Rating, count(*) as Count_movies
from t1 
group by IMDB_Rating
order by Count_movies desc;

8. Do higher-rated movies tend to have higher gross revenue?

SELECT
    'score-gross' AS correlation_type,
    AVG(score * gross) - AVG(score) * AVG(gross) AS covariance,
    STDEVP(score) AS stdev_score,
    STDEVP(gross) AS stdev_gross,
    (AVG(score * gross) - AVG(score) * AVG(gross)) / (STDEVP(score) * STDEVP(gross)) AS correlation_coefficient
FROM movies$
WHERE score IS NOT NULL AND gross IS NOT NULL;

9. Are there any trends in user ratings over time?

select year , AVG(score) as AVG_rating
from movies$
group by year
order by year asc;

10. How has the number of movies released each year changed over time?

select YEAR, Count(name) as Movies_count 
from movies$
group by year
order by year asc;

11. How has the popularity of different genres evolved?

% of genre
genre
year

WITH GenreCounts AS 
    (SELECT
        Year,Genre,COUNT(*) AS GenreCount
    FROM movies$
    GROUP BY Year, Genre),
YearTotalCounts AS 
    (SELECT
        Year, COUNT(*) AS TotalCount
    FROM movies$
    GROUP BY Year)
SELECT
    GC.Year,
    GC.Genre,
    GC.GenreCount,
    YTC.TotalCount,
    (CAST(GC.GenreCount AS DECIMAL) / CAST(YTC.TotalCount AS DECIMAL)) * 100 AS GenrePercentage
FROM
    GenreCounts GC
JOIN
    YearTotalCounts YTC ON GC.Year = YTC.Year
ORDER BY
    GC.Year,
    GenrePercentage DESC;

12. Which genres tend to have the highest user ratings?

select genre, AVG(score) AS Avg_user_rating
from movies$
group by genre 
order by Avg_user_rating desc;















