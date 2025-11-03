SELECT 
    d.year, r.region_name, p.population,
    MAX(fc.deceased) AS total_deaths
FROM dw_layer.fact_covid_cases fc
JOIN dw_layer.dimDate d 
    ON fc.date_key = d.datekey
JOIN dw_layer.dimRegion r 
    ON fc.region_key = r.regionKey
JOIN (
    SELECT year, region_key, SUM(total_count) AS population
    FROM dw_layer.fact_population
    GROUP BY year, region_key
) p 
    ON p.region_key = fc.region_key
   AND p.year = d.year
WHERE d.year BETWEEN 2020 AND 2022
GROUP BY d.year, r.region_name,  p.population
ORDER BY d.year, r.region_name;
