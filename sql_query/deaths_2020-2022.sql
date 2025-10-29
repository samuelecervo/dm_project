SELECT
    c_year.year,
    r.region_name,
    p.population,
    c_year.total_deaths
FROM (
    SELECT
        EXTRACT(YEAR FROM date_key) AS year,
        region_key,
        MAX(deceased) AS total_deaths
    FROM dw_layer.fact_covid_cases
    WHERE EXTRACT(YEAR FROM date_key) BETWEEN 2020 AND 2022
    GROUP BY EXTRACT(YEAR FROM date_key), region_key
) c_year
JOIN (
    SELECT
        year,
        region_key,
        SUM(total_count) AS population
    FROM dw_layer.fact_population
    GROUP BY year, region_key
) p
    ON c_year.region_key = p.region_key
   AND c_year.year = p.year
JOIN dw_layer.dimRegion r
    ON c_year.region_key = r.regionKey
ORDER BY c_year.year, r.region_name;
