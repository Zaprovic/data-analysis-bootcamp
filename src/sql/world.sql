use world;

with
    cities as (
        select
            co.`Code` as `Country Code`,
            max(ci.`Population`) as `Max Population`
        from city ci
            inner join country co on ci.`CountryCode` = co.`Code`
        group by
            `Country Code`
    ),
    avg_population as (
        select avg(`Max Population`) as `Average Population`
        from cities
    )
select
    `Country Code`,
    `Max Population`
from cities, avg_population
where
    `Max Population` < `Average Population`
order by `Max Population`;

with
    mps as (
        with
            mp as (
                select
                    co.`Code` as `Country Code`,
                    ci.`Name` as `City Name`,
                    ci.`Population` as `City Population`
                from city ci
                    inner join country co on ci.`CountryCode` = co.`Code`
                where
                    ci.`Population` = (
                        select max(cc.`Population`)
                        from city cc
                        where
                            cc.`CountryCode` = ci.`CountryCode`
                    )
            ),
            avg_population as (
                select avg(`City Population`) as `Average Population`
                from mp
            )
        select
            `Country Code`,
            `City Name`,
            `City Population`
        from mp, avg_population
        where
            `City Population` < `Average Population`
        order by `Country Code`
    )
select
    co.`Name` as `Country Name`,
    `City Name`,
    `City Population`,
    `SurfaceArea` as `Country Surface Area`,
    `City Population` / `SurfaceArea` as `Population Density`
from mps
    inner join country co on co.`Code` = mps.`Country Code`;

with
    max_cities as (
        select
            co.`Name` as `Country Name`,
            max(ci.`Population`) as `Max Population`
        from city ci
            inner join country co on ci.`CountryCode` = co.`Code`
        group by
            co.`Name`
    ),
    min_cities as (
        select
            co.`Name` as `Country Name`,
            min(ci.`Population`) as `Min Population`
        from city ci
            inner join country co on ci.`CountryCode` = co.`Code`
        group by
            co.`Name`
    ),
    avg_val as (
        select avg(`Min Population`) as `Average Population`
        from min_cities
    )
select
    `Country Name`,
    `Max Population`
from max_cities, avg_val
where
    `Max Population` < avg_val.`Average Population`;

with
    min_cities as (
        select
            co.`Name` as `Country Name`,
            min(ci.`Population`) as `Min Population`
        from city ci
            inner join country co on ci.`CountryCode` = co.`Code`
        group by
            co.`Name`
    )
select avg(`Min Population`)
from min_cities;

with
    max_cities as (
        select
            co.`Name` as `Country Name`,
            max(ci.`Population`) as `Max Population`
        from city ci
            inner join country co on ci.`CountryCode` = co.`Code`
        group by
            co.`Name`
    ),
    min_cities as (
        select
            co.`Name` as `Country Name`,
            min(ci.`Population`) as `Min Population`
        from city ci
            inner join country co on ci.`CountryCode` = co.`Code`
        group by
            co.`Name`
    )
select *
from max_cities, min_cities
where
    `Max Population` < (
        select avg(`Min Population`)
        from min_cities
    );