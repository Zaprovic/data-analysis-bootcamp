use sakila;

select * from film_list;

WITH
    split_actors AS (
        SELECT
            FID,
            title,
            category,
            price,
            length,
            rating,
            jt.actor
        FROM film_list, JSON_TABLE(
                CONCAT(
                    '["',
                    REPLACE (actors, ', ', '","'), '"]'
                ), '$[*]' COLUMNS (actor VARCHAR(255) PATH '$')
            ) AS jt
    )
SELECT *
FROM split_actors;

select
    f.film_id,
    f.title as movie,
    fl.price,
    f.length,
    l.name as language,
    ll.name as original_language,
    c.name as category,
    a.first_name,
    a.last_name,
    f.release_year
from
    film f
    inner join language l on f.language_id = l.language_id
    inner join film_category fc on fc.film_id = f.film_id
    inner join category c on c.category_id = fc.category_id
    inner join film_actor fa on fa.film_id = f.film_id
    inner join actor a on a.actor_id = fa.actor_id
    left join language ll on ll.language_id = f.original_language_id
    inner join film_list fl on fl.FID = f.film_id
order by film_id;

select count(*), c.name as category
from
    film f
    inner join language l on f.language_id = l.language_id
    inner join film_category fc on fc.film_id = f.film_id
    inner join category c on c.category_id = fc.category_id
    inner join film_actor fa on fa.film_id = f.film_id
    inner join actor a on a.actor_id = fa.actor_id
    left join language ll on ll.language_id = f.original_language_id
group by
    c.name
order by c.name desc;

select ci.city_id, ci.city as city_name, co.country_id, co.country as country_name
from city ci
    inner join country co on co.country_id = ci.country_id;