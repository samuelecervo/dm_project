WITH yearly_vaccinations AS (
    SELECT
        EXTRACT(YEAR FROM date_key) AS year,
        region_key,
        age_key,
        SUM(first_dose) AS total_vaccinations
    FROM dw_layer.fact_vaccination
    GROUP BY EXTRACT(YEAR FROM date_key), region_key, age_key
)

SELECT
    yv.year,
    r.region_name,
    a.age_group,
    yv.total_vaccinations,
    fp.total_count AS population,
    ROUND(yv.total_vaccinations / fp.total_count * 100, 2) AS vaccination_rate_percent
FROM yearly_vaccinations yv
JOIN dw_layer.fact_population fp
    ON yv.region_key = fp.region_key
    AND yv.age_key = fp.age_key
    AND yv.year = fp.year
JOIN dw_layer.dimRegion r
    ON yv.region_key = r.regionKey
JOIN dw_layer.dimAgeRange a
    ON yv.age_key = a.age_key
ORDER BY yv.year, r.region_name, a.age_group;
