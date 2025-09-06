create table netflix1
(
 	type
	 title varchar(10),
	 director varchar(210),
	 cast varchar(800),
	 country varch
	 date_added
	 release_year
	 rating
	 duration
	 listed_in
	 description

)

DROP TABLE IF EXISTS netflix1;
CREATE TABLE netflix1
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
    description  VARCHAR(1000)
);

select * from netflix1;


select * from netflix1;
select 
	count (*) as total_count
	from netflix1;

select 
	distinct type
	from netflix1;

	-- count of total movies and tv shows



select type , count(*) as total_TV_shows
from netflix1
where type = 'TV Show'
group by type;

select type , count(*) as total_movies
from netflix1
group by type;

-- find the most common rating for movies and tv shows

select * from netflix1;

select distinct type , rating 
from netflix1;

select type, rating 
from
(
	select 
			type,
			rating,
			count(*),
			rank() over(partition by type order by count(*) desc)as ranking
			from netflix1
			group by 1,2
			) as t1
where ranking = 1		

-- list all movis released in specific year

select * from netflix1;

select title as movies2020
from netflix1
where release_year=2020;

-- find top five contries with most content on netflix

select * from netflix1;

select country ,count(country)as count_of_shows
from netflix1
group by 1
order by 2 desc
limit 5
;

-- identyfy the longest movie

select title, duration 
from netflix1
where type = 'Movie'
and duration is not null
and duration  like '____min'
	order by duration desc
	limit 1;

	-- content added in last five years

SELECT *
FROM netflix1
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

		-- find all movies and tv shows by rajiv chilaka

	select *
	from netflix1
	where director like '%Rajiv Chilaka%';

	-- list all tv shows with more than a 5 seasons

select * 
from netflix1
where type = 'TV Show'
and
split_part(duration, ' ',1)::numeric >= 5;

-- count no of content in each genre (listed_in)

select distinct listed_in, count(*) as c
from netflix1
group by listed_in
order by c desc ;

select 
		unnest( string_to_array(listed_in,',')) as genre, 
		count(show_id) as total_content
from netflix1
group by genre
order by 2 desc;

-- find each year and the avg numbers of content release in indiaon netflix return top 5 years with avg content release

select
		extract(year from to_date(date_added, 'Month DD,YYYY'))as year,
		count(*)as yearly_content,
		round(
				count(*)::numeric/ (select count(*)from netflix1 where country= 'India')::numeric*100
				,2)as average_content_per_year
from netflix1 
where country = 'India'
group by 1;

-- list all content that is documentries

select * from netflix1
 where listed_in ilike '%documentaries%';

 -- find all content without a director

 select * from netflix1
 where director is null;

 -- slect how many movies salman khan appeared in last 10 years

 select * from netflix1
 where casts ilike '%Salman Khan%'
 and 
 where release_year >= 2015;

  select * from netflix1
 where casts ilike '%Salman Khan%'
 and 
  release_year > extract( year from current_date)-10;

  -- find the top 10 actors who have appeared in the highest no of movies produced in india

  select --title,	 country,  casts,
  		unnest (string_to_array(casts, ',')) as actor,
		  count(*) as total_content
  from netflix1
  where country ilike '%india%'
  group by 1
  order by 2 desc
  limit 10;

  -- categorize the content based on the presence of the keywords 'kill' and violence 
  -- in the discription filed . 
  --lable content containing this keywords as 'bad'
 -- and all other content as 'Good'
-- count how many items fall into each category


with new_table 
as(
select *,
		case
		when
			description ilike '%Kill%'
or description ilike '%violence%' then 'Good_Content'
else 'Bad_Content'
end category
			from netflix1
)
select category,
		count(*) as total_content
		from new_table 
		group by 1


;