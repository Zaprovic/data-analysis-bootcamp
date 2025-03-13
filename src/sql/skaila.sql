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