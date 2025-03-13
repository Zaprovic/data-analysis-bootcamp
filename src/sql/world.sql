USE world;

SELECT
    cl.`CountryCode`,
    cl.`Language`,
    cl.`IsOfficial`,
    cl.`Percentage`,
    co.`Name` as `Country name`,
    co.`Population` as `Country population`,
    co.`Continent`,
    co.`Region`,
    ci.`Name` as `City name`,
    ci.`District`,
    ci.`Population` as `City population`
FROM
    countrylanguage cl
    INNER JOIN country co on co.`Code` = cl.`CountryCode`
    INNER JOIN city ci on ci.`CountryCode` = cl.`CountryCode`;