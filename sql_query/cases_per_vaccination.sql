WITH positives_cumulative AS (
    SELECT
        fc.date_key,
        fc.region_key,
        SUM(fc.new_positives) OVER (PARTITION BY fc.region_key ORDER BY fc.date_key) AS cumulative_cases,
        SUM(fv.first_dose + fv.second_dose + fv.booster) OVER (PARTITION BY fc.region_key ORDER BY fc.date_key) AS cumulative_vaccinations
    FROM dw_layer.fact_covid_cases fc
    JOIN dw_layer.fact_vaccination fv
        ON fc.region_key = fv.region_key
        AND fc.date_key = fv.date_key
)
SELECT
    EXTRACT(YEAR FROM d.date) AS year,
    r.region_name,
    MAX(pc.cumulative_cases) AS total_cases_cumulative,
    MAX(pc.cumulative_vaccinations) AS total_vaccinations_cumulative,
    ROUND(
        MAX(pc.cumulative_cases)::numeric / NULLIF(MAX(pc.cumulative_vaccinations),0), 4) * 100 AS cases_per_vaccination_pct
FROM positives_cumulative pc
JOIN dw_layer.dimRegion r
    ON pc.region_key = r.regionKey
JOIN dw_layer.dimDate d
    ON pc.date_key = d.dateKey
GROUP BY EXTRACT(YEAR FROM d.date), r.region_name
ORDER BY EXTRACT(YEAR FROM d.date), r.region_name;
